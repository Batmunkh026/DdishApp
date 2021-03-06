import 'dart:async';

import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:ddish/src/models/branch.dart';
import 'package:ddish/src/widgets/dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  //default ub zoom
  double zoom = 9.8;
  LatLng position = LatLng(47.9179405, 106.9132983);

  Map<String, BitmapDescriptor> _markerIcons = Map<String, BitmapDescriptor>();

  Completer<GoogleMapController> _mapController = Completer();

  final _branchFilterStreamController = StreamController<BranchFilter>();

  final branchNames = ["ddish", "unitel"];
  final branchStates = ["open", "closed"];

  Branch selectedBranch = null;

  bool isStateFilter = false;

  var textStyle =
      TextStyle(color: Color.fromRGBO(202, 224, 252, 1), fontSize: 12);

  bool _mapIsUpdating = false;

  @override
  void initState() {
    _bloc = MenuBloc(this);
    _bloc.getBranchParam().then((params) {
      setState(() => _params = params);
      selectedArea = params.branchAreas.first;
      BranchType type = params.branchTypes.first;
      BranchService service = params.branchServices.first;
      _branchFilterStreamController.sink
          .add(BranchFilter(selectedArea, type, null, service));
    });

    _branchFilterStreamController.stream.listen((branchFilter) {
      _mapIsUpdating = true;
      //branch location data load
      _bloc
          .getBranches(branchFilter.cityCode, branchFilter.typeCode,
              branchFilter.serviceCode)
          .then((branches) {
        setState(() {
          this.branches = branches;
          _loading = false;
          _mapIsUpdating = false;
          if (isStateFilter) filterByBranchState();
        });
      });
    }).onDone(() => print("filtered."));

    super.initState();
  }

  double pickersContainerHeight = 0;
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;

    double height = deviceHeight * (deviceHeight < 600 ? 0.35 : 0.4);
    double width = MediaQuery.of(context).size.width;
    pickersContainerHeight = deviceHeight * 0.2;

    //state filter нь service учир static зааж өглөө
    //TODO тодруулах
    isStateFilter = selectedState != null &&
        selectedState.isNotEmpty &&
        selectedState != "Бүгд";

    _loadMarkerImages(context);

    if (_loading)
      return Center(
        child: CircularProgressIndicator(),
      );

    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: pickersContainerHeight,
            width: width * 0.84,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: createFilterComponents(branches),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            height: height,
            child: Stack(
              children: <Widget>[
                Card(child: createGoogleMap()),
                Visibility(
                  child: Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  visible: _mapIsUpdating,
                )
              ],
            ),
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
    var defaultStyle = TextStyle(
        fontSize: 12,
        color: Color.fromRGBO(202, 224, 252, 1),
        fontFamily: "Montserrat");

    Selector itemSelector = Selector(
      items: items,
      onSelect: (selectedItem) => Function.apply(event, [selectedItem]),
      initialValue: selectedItem,
      defaultTextStyle: defaultStyle,
      childMap: (item) {
        return Center(
          child: Container(
            child: Text(
              item is String ? item : item.name,
              style: TextStyle(fontSize: 12, fontFamily: "Montserrat"),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );

    return Container(
      height: pickersContainerHeight * .5,
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
              height: MediaQuery.of(context).size.height < 620 ? 26 : 34,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1.0,
                      style: BorderStyle.solid,
                      color: textStyle.color),
                  borderRadius: BorderRadius.all(Radius.circular(33.0)),
                ),
              ),
              child: itemSelector,
            ),
          )
        ],
      ),
    );
  }

  createSelectorColumn(selector1, selector2) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: 133 + (width / 370),
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
                  if (area.code == "ub") {
                    zoom = 9.8;
                    position = LatLng(47.9179405, 106.9132983);
                  } else {
                    zoom = 3.6;
                    position = LatLng(47.9179405, 103.9132983);
                  }
                  _mapController.future.then((_controller) => _controller
                      .moveCamera(CameraUpdate.newLatLngZoom(position, zoom)));
                  addToBranchFilterStream();
                }),
            selectedArea),
        createSelector(
            "Салбарын төлөв",
            ["Бүгд", "Нээлттэй"],
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

    var deviceWidth = MediaQuery.of(context).size.width;
    var addressContainerWidth = deviceWidth * 0.35;

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
                style: TextStyle(color: textStyle.color, fontSize: 14),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ConstrainedBox(
                  constraints:
                      BoxConstraints(minWidth: 1, maxWidth: deviceWidth * .5),
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: RichText(
                      softWrap: true,
                      text: TextSpan(
                          text: clearSpecialChars(selectedBranch.address),
                          style: textStyle),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: createTimeTableWidgets(selectedBranch),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  GoogleMap createGoogleMap() {
    final CameraPosition defaultPosition = CameraPosition(
      target: position,
      zoom: zoom,
    );
    return GoogleMap(
      markers: (isStateFilter ? widget.filteredBranch : branches)
          .map((branch) => createMarker(branch.lat, branch.lon, branch))
          .toSet(),
      initialCameraPosition: defaultPosition,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
      onMapCreated: (controller) {
        _mapController.complete(controller);
      },
    );
  }

  Marker createMarker(double latitude, double longitude, Branch branch) {
    var position = LatLng(latitude, longitude);

    bool isClosed = branch.state != 'Нээлттэй';

    var icon = _getMarkerIcon(isClosed, branch.type);
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

  ///branchType нь аль салбар болохыг илтгэнэ.
  ///
  /// дараах бүтэцтэй утга ирнэ
  /// 'all, ddish', 'unitel'
  ///
  /// iconName ыг агуулсан салбарын төрөл байвал тухайн харгалзах icon ыг нээлттэй, хаалттай төлвөөс хамааран ялгаж өгнө.
  ///
  /// хэрэв тийм icon олдоогүй бол ddish default icon буцаана.
  ///
  BitmapDescriptor _getMarkerIcon(bool isClosed, String branchType) {
    String _state = isClosed ? "closed" : "open";
    String key = _markerIcons.keys.firstWhere(
        (_name) =>
            branchType.contains(_name.split("_")[0]) && _name.endsWith(_state),
        orElse: () => branchNames[0] + "_$_state");

    return _markerIcons[key];
  }

  ///marker icon уудыг уншаад
  ///салбарын нэр болон салбарын төлөв ийн хамт map д хадгалах
  ///
  /// {'ddish_open':openIcon, 'ddish_closed':closedIcon}
  _loadMarkerImages(BuildContext context) {
    if (_markerIcons.isEmpty) {
      final ImageConfiguration config = createLocalImageConfiguration(context);

      branchNames.forEach((branchName) => branchStates.forEach((branchState) {
            String branchInfo = "${branchName}_$branchState";
            String fileName = 'assets/map/$branchInfo.png';
            BitmapDescriptor.fromAssetImage(config, fileName).then((icon) {
              //[unitel_closed, unitel_open]...
              setState(
                  () => _markerIcons.putIfAbsent("$branchInfo", () => icon));
            });
          }));
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
