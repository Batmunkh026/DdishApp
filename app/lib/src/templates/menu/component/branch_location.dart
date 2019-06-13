import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:ddish/src/blocs/menu/menu_event.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';
import 'package:ddish/src/models/branch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BranchLocationView extends StatefulWidget {
  MenuBloc bloc;
  @override
  State<StatefulWidget> createState() => BranchLocationState();
}

class BranchLocationState extends State<BranchLocationView> {
  Completer<GoogleMapController> _mapController = Completer();

  final _branchFilterStreamController = StreamController<BranchFilter>();
  final _filteredBranchesStreamController = StreamController<List<Branch>>();

  Branch selectedBranch = Branch.empty();

  List<Branch> branches;

  var textStyle =
      TextStyle(color: Color.fromRGBO(202, 224, 252, 1), fontSize: 12);

  @override
  void initState() {
    widget.bloc = BlocProvider.of<MenuBloc>(context);
    branches = widget.bloc.getDemoBranchLocations();

    _filteredBranchesStreamController.sink.add(branches);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.4;

    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: createFilterComponents(branches)),
          Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            height: height,
            child: Card(child: createGoogleMap()),
          ),
          createInfoOfSelectedbranch(), //сонгосон салбарын цагийн хуваарь, байршлын мэдээллийн хэсэг
        ],
      ),
    );
  }

  Widget createSelector(
      String title, List<String> items, Function(String item) event) {
    Function(String item) event;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: textStyle),
        DropdownButton<String>(
          icon: Icon(Icons.keyboard_arrow_down),
          items: items
              .map((item) => DropdownMenuItem(child: Text(item), value: item))
              .toList(),
          onChanged: (selectedItem) => event,
        )
      ],
    );
  }

  ///шүүх
  filterBranches({String city, String type, String state, String service}) {
    var newFilter =
        BranchFilter(city: city, type: type, state: state, service: service);

    _branchFilterStreamController.stream.listen((oldFilter) {
      if (newFilter.city.isEmpty && oldFilter.city.isNotEmpty)
        newFilter.city = oldFilter.city;

      if (newFilter.type.isEmpty && oldFilter.type.isNotEmpty)
        newFilter.type = oldFilter.type;

      if (newFilter.state.isEmpty && oldFilter.state.isNotEmpty)
        newFilter.state = oldFilter.state;

      if (newFilter.service.isEmpty && oldFilter.service.isNotEmpty)
        newFilter.service = oldFilter.service;
    }).onDone(() {
      _branchFilterStreamController.sink.add(newFilter);
      _branchFilterStreamController.stream.listen((filter) {
        //TODO салбарыг шүүж үр дүнг stream controller руу дамжуулах
        _filteredBranchesStreamController.add(branches);
      });
    });
  }

  List<String> mapToServices(List<Branch> branches) {
    return branches
        .map((branch) => branch.services.toSet())
        .expand((item) => item)
        .toSet()
        .toList();
  }

  List<String> mapToTypes(List<Branch> branches) {
    return branches.map((branch) => branch.type).toSet().toList();
  }

  List<String> mapToCities(List<Branch> branches) {
    return branches.map((branch) => branch.city).toSet().toList();
  }

  List<String> mapToStates(List<Branch> branches) {
    return branches.map((branch) => branch.state).toSet().toList();
  }

  ///Шүүлтүүрүүд
  List<Widget> createFilterComponents(List<Branch> branches) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          createSelector("Хот, Аймаг", mapToCities(branches),
              (city) => filterBranches(city: city)),
          createSelector("Салбарын төрөл", mapToTypes(branches),
              (type) => filterBranches(type: type)),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          createSelector("Салбарын төлөв", mapToStates(branches),
              (branchState) => filterBranches(state: branchState)),
          createSelector("Үзүүлэх үйлчилгээ", mapToServices(branches),
              (service) => filterBranches(service: service)),
        ],
      ),
    ];
  }

  ///сонгосон салбарын цагийн хуваарь, байршлын мэдээлэл
  Widget createInfoOfSelectedbranch() {
    List<String> weekRange = selectedBranch.weekRange;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            selectedBranch.name,
            style: TextStyle(color: textStyle.color, fontSize: 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: RichText(
                  softWrap: true,
                  text:
                      TextSpan(text: selectedBranch.address, style: textStyle),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    weekRange.isEmpty ? "" : weekRange[0],
                    style: textStyle,
                  ),
                  Text(
                    weekRange.isEmpty ? "" : weekRange[1],
                    style: textStyle,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  GoogleMap createGoogleMap() {
    final CameraPosition defaultPosition = CameraPosition(
      target: LatLng(47.9179405, 106.9132983),
      zoom: 14.4746,
    );
    return GoogleMap(
      markers: branches
          .map((branch) => createMarker(branch.lat, branch.lon, branch))
          .toSet(),
      initialCameraPosition: defaultPosition,
      onMapCreated: (controller) {
        _mapController.complete(controller);
      },
    );
  }

  Marker createMarker(double latitude, double longitude, Branch branch,
      {double width = 180,
      double height = 180,
      IconData iconData,
      Color color}) {
    var position = LatLng(latitude, longitude);

    return Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: branch.name,
          snippet: branch.address + " - " + branch.weekRange.toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () => setState(() {
              this.selectedBranch = branch;
            }));
  }

  @override
  void dispose() {
    _branchFilterStreamController.close();
    _filteredBranchesStreamController.close();
    super.dispose();
  }
}
