import 'dart:async';

import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:ddish/src/models/branch.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BranchLocationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BranchLocationState();
}

class BranchLocationState extends State<BranchLocationView> {
  final MenuBloc bloc = MenuBloc();

  List<Branch> branches = [];
  BranchParam _params;
  bool _loading = true;

  var selectedState;
  BranchArea selectedArea;
  BranchType selectedType;
  BranchService selectedService;

  BitmapDescriptor markerIconClosed;
  BitmapDescriptor markerIconOpen;

  Completer<GoogleMapController> _mapController = Completer();

  final _branchFilterStreamController = StreamController<BranchFilter>();

  Branch selectedBranch = null;

  var textStyle =
      TextStyle(color: Color.fromRGBO(202, 224, 252, 1), fontSize: 13.0);

  @override
  void initState() {
    bloc.getBranchParam().then((params) {
      setState(() {
        _params = params;
      });
      selectedArea = params.branchAreas.first;
      BranchType type = params.branchTypes.first;
      BranchService service = params.branchServices.first;
      _branchFilterStreamController.sink
          .add(BranchFilter(selectedArea, type, null, service));
    });

    _branchFilterStreamController.stream.listen((branchFilter) {
      //branch location data load
      bloc
          .getBranches(branchFilter.cityCode, branchFilter.typeCode,
              branchFilter.serviceCode)
          .then((branches) {
        setState(() {
          this.branches = branches;
          _loading = false;
        });
      });
    }).onDone(() {
      print("filtered.");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.4;

    loadMarkerImages(context);

    if (_loading)
      return Center(
        child: CircularProgressIndicator(),
      );

    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: createFilterComponents(branches)),
          ),
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

  Widget createSelector(String title, List<dynamic> items,
      Function(dynamic) event, selectedItem) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            child: Text(
              title,
              style: textStyle,
            ),
            padding: EdgeInsets.only(bottom: 8),
          ),
          Theme(
              data: ThemeData(canvasColor: Theme.of(context).primaryColor),
              child: Container(
                padding: EdgeInsets.only(right: 5, left: 5, top: 0, bottom: 0),
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: textStyle.color),
                    borderRadius: BorderRadius.all(Radius.circular(33.0)),
                  ),
                ),
                child: DropdownButton<dynamic>(
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: textStyle.color,
                  ),
                  underline: Container(),
                  items: items
                      .map(
                        (item) => DropdownMenuItem(
                            child: Center(
                              child: Text(
                                item.name,
                                style: TextStyle(
                                    fontSize: textStyle.fontSize,
                                    color: textStyle.color),
                              ),
                            ),
                            value: item),
                      )
                      .toList(),
                  value: selectedItem == null && items.isNotEmpty
                      ? items.first
                      : selectedItem,
                  onChanged: (selectedItem) =>
                      Function.apply(event, [selectedItem]),
                ),
              ))
        ],
      ),
    );
  }

  ///Шүүлтүүрүүд
  List<Widget> createFilterComponents(List<Branch> branches) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          createSelector(
              "Хот, Аймаг",
              _params.branchAreas,
              (area) => setState(() {
                    this.selectedArea = area;
                    addToBranchFilterStream();
                  }),
              selectedArea),
          createSelector(
              "Салбарын төрөл",
              _params.branchTypes,
              (type) => setState(() {
                    this.selectedType = type;
                    addToBranchFilterStream();
                  }),
              selectedType),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          createSelector(
              "Салбарын төлөв",
              [],
              (branchState) => setState(() {
                    this.selectedState = branchState;
                    addToBranchFilterStream();
                  }),
              selectedState),
          createSelector(
              "Үзүүлэх үйлчилгээ",
              _params.branchServices,
              (service) => setState(() {
                    this.selectedService = service;
                    addToBranchFilterStream();
                  }),
              selectedService),
        ],
      ),
    ];
  }

  ///сонгосон салбарын цагийн хуваарь, байршлын мэдээлэл
  Widget createInfoOfSelectedbranch() {
    if (selectedBranch == null) return Container();

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
              Column(children: createTimeTableWidgets(selectedBranch))
            ],
          )
        ],
      ),
    );
  }

  GoogleMap createGoogleMap() {
    final CameraPosition defaultPosition = CameraPosition(
      target: LatLng(47.9179405, 106.9132983),
      zoom: 10.4746,
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

  Marker createMarker(double latitude, double longitude, Branch branch) {
    var position = LatLng(latitude, longitude);

    var icon = branch.state == 'Хаалттай' ? markerIconClosed : markerIconOpen;
    return Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: branch.name,
        snippet: branch.address,
      ),
      icon: icon,
      onTap: () => setState(() {
            this.selectedBranch = branch;
          }),
    );
  }

  @override
  void dispose() {
    _branchFilterStreamController.close();
    bloc.dispose();
    super.dispose();
  }

  List<Widget> createTimeTableWidgets(Branch selectedBranch) {
    return selectedBranch.timeTable.split("&&&").map((dayAndTime) {
      List dayTimes = dayAndTime.split("@");
      List<String> days = dayTimes[0].split(",");
      String time = dayTimes[1];
      return Text("${days.first} - ${days.last}: $time", style: textStyle);
    }).toList();
  }

  loadMarkerImages(BuildContext context) {
    if (markerIconClosed == null) {
      final ImageConfiguration config = createLocalImageConfiguration(context);

      BitmapDescriptor.fromAssetImage(config, 'assets/location_closed.png')
          .then((icon) => setState(() => markerIconClosed = icon));

      BitmapDescriptor.fromAssetImage(config, 'assets/location_open.png')
          .then((icon) => setState(() => markerIconOpen = icon));
    }
  }

  void addToBranchFilterStream() {
    _branchFilterStreamController.sink.add(BranchFilter(
        selectedArea, selectedType, selectedState, selectedService));
  }
}
