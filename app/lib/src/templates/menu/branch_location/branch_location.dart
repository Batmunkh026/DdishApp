import 'dart:async';

import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:ddish/src/models/branch.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BranchLocationView extends StatefulWidget {
  List<Branch> filteredBranch = [];
  @override
  State<StatefulWidget> createState() => BranchLocationState();
}

class BranchLocationState extends State<BranchLocationView> {
  MenuBloc _bloc;

  List<Branch> branches = [];
  BranchParam _params;
  bool _loading = true;

  String selectedState;
  BranchArea selectedArea;
  BranchType selectedType;
  BranchService selectedService;

  BitmapDescriptor markerIconClosed;
  BitmapDescriptor markerIconOpen;

  Completer<GoogleMapController> _mapController = Completer();

  final _branchFilterStreamController = StreamController<BranchFilter>();

  Branch selectedBranch = null;

  bool isStateFilter = false;

  var textStyle =
      TextStyle(color: Color.fromRGBO(202, 224, 252, 1), fontSize: 11);

  @override
  void initState() {
    _bloc = MenuBloc(this);
    _bloc.getBranchParam().then((params) {
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
      _bloc
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

  double pickersContainerHeight = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.4;
    pickersContainerHeight = MediaQuery.of(context).size.height * 0.18;

    //state filter нь service учир static зааж өглөө
    //TODO тодруулах
    isStateFilter = selectedState != null &&
        selectedState.isNotEmpty &&
        selectedState != "Бүгд";

    loadMarkerImages(context);

    if (_loading)
      return Center(
        child: CircularProgressIndicator(),
      );

    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: pickersContainerHeight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: createFilterComponents(branches)),
          ),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            height: height,
            child: Card(child: createGoogleMap()),
          ),
          Flexible(
            child: createInfoOfSelectedbranch(),
          ), //сонгосон салбарын цагийн хуваарь, байршлын мэдээллийн хэсэг
        ],
      ),
    );
  }

  Widget createSelector(String title, List<dynamic> items,
      Function(dynamic) event, selectedItem) {
    return Container(
      height: pickersContainerHeight / 2.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              title,
              style: textStyle,
            ),
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
                            child: Container(
                              padding: EdgeInsets.all(3),
                              child: Text(
                                item is String ? item : item.name,
                                style: TextStyle(
                                    color: Color.fromRGBO(202, 224, 252, 1),
                                    fontSize: 12),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
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
            ),
          )
        ],
      ),
    );
  }

  createSelectorColumn(selector1, selector2) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          selector1,
          selector2,
        ],
      ),
    );
  }

  ///Шүүлтүүрүүд
  List<Widget> createFilterComponents(List<Branch> branches) {
    return [
      createSelectorColumn(
        createSelector(
            "Хот, Аймаг",
            _params.branchAreas,
            (area) => setState(() {
                  this.selectedArea = area;
                  addToBranchFilterStream();
                }),
            selectedArea),
        createSelector(
            "Салбарын төлөв",
            ["Бүгд", "Нээлттэй", "Хаалттай"],
            (branchState) => setState(() {
                  this.selectedState = branchState;
                  filterByBranchState();
                }),
            selectedState),
      ),
      createSelectorColumn(
        createSelector(
            "Салбарын төрөл",
            _params.branchTypes,
            (type) => setState(() {
                  this.selectedType = type;
                  addToBranchFilterStream();
                }),
            selectedType),
        createSelector(
            "Үзүүлэх үйлчилгээ",
            _params.branchServices,
            (service) => setState(() {
                  this.selectedService = service;
                  addToBranchFilterStream();
                }),
            selectedService),
      ),
    ];
  }

  ///сонгосон салбарын цагийн хуваарь, байршлын мэдээлэл
  Widget createInfoOfSelectedbranch() {
    if (selectedBranch == null) return Container();

    var addressContainerWidth = MediaQuery.of(context).size.width * 0.35;

    return Padding(
      padding: EdgeInsets.all(5),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                selectedBranch.name,
                style: TextStyle(color: textStyle.color),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: addressContainerWidth,
                  margin: EdgeInsets.only(right: 15),
                  child: RichText(
                    softWrap: true,
                    text: TextSpan(
                        text: clearSpecialChars(selectedBranch.address),
                        style: textStyle),
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: createTimeTableWidgets(selectedBranch))
              ],
            )
          ],
        ),
      ),
    );
  }

  GoogleMap createGoogleMap() {
    final CameraPosition defaultPosition = CameraPosition(
      target: LatLng(47.9179405, 106.9132983),
      zoom: 10.4746,
    );
    return GoogleMap(
      markers: (isStateFilter ? widget.filteredBranch : branches)
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
        snippet: clearSpecialChars(branch.address),
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
    _bloc.dispose();
    super.dispose();
  }

  List<Widget> createTimeTableWidgets(Branch selectedBranch) {
    return selectedBranch.timeTable.split("&&&").map((dayAndTime) {
      List dayTimes = dayAndTime.split("@");
      List<String> days = dayTimes[0].split(",");
      String time = dayTimes[1];

      return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text("${days.first.trim()} - ${days.last}:",
                  style: textStyle),
              margin: EdgeInsets.only(right: 10),
            ),
            Text(
              "$time",
              style: textStyle,
            )
          ],
        ),
      );
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
    setState(() => selectedBranch = null);
  }

  void filterByBranchState() {
    setState(() {
      selectedBranch = null;
      if (selectedState == "Бүгд")
        widget.filteredBranch.clear();
      else
        widget.filteredBranch =
            branches.where((b) => b.state == selectedState).toList();
    });
  }

  String clearSpecialChars(String address) =>
      address.replaceAll(RegExp(r'\\n|\\r'), "");
}
