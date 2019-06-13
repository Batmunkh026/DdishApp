import 'package:meta/meta.dart';

///Салбар
class Branch {
  double lat;
  double lon;
  String city;
  String type; //TODO салбарын төрөл ямар төрлийн өгөгдөл байх
  String state; //TODO салбарын төлөв ямар төрлийн өгөгдөл байх
  List<String> services;
  String name;
  String address;
  List<String>
  weekRange; //Долоон хоногийн гаригуудын range : эхлэх - дуусах цаг:мин (pl)

  Branch(
      @required this.lat,
      @required this.lon,
      @required this.city,
      @required this.type,
      @required this.state,
      @required this.services,
      @required this.name,
      @required this.address,
      @required this.weekRange);

  static Branch empty() => Branch(0.0, 0.0, "", "", "", [], "", "", []);
}

class BranchFilter {
  String city = "";
  String type = ""; //TODO салбарын төрөл ямар төрлийн өгөгдөл байх
  String state = ""; //TODO салбарын төлөв ямар төрлийн өгөгдөл байх
  String service = "";

  BranchFilter(
      {String city = "",
        String type = "",
        String state = "",
        String service = ""}) {
    if (city.isNotEmpty) this.city = city;
    if (type.isNotEmpty) this.type = type;
    if (state.isNotEmpty) this.state = state;
    if (service.isNotEmpty) this.service = service;
  }
}