import 'package:meta/meta.dart';

///Салбар
class Branch {
  int id;
  double lat;
  double lon;
  String city = "UB";
  String type; //TODO салбарын төрөл ямар төрлийн өгөгдөл байх
  String state; //TODO салбарын төлөв ямар төрлийн өгөгдөл байх
  List<String> services = ["test"];
  String name;
  String address;
  String img;
  String timeTable;
  //Долоон хоногийн гаригуудын range : эхлэх - дуусах цаг:мин (pl)

  Branch(
      @required this.id,
      @required this.lat,
      @required this.lon,
      @required this.city,
      @required this.type,
      @required this.services,
      @required this.name,
      @required this.address,
      @required this.timeTable,
      this.img);

  Branch.fromJson(Map<String, dynamic> branchMap)
      : id = int.parse(branchMap["branchId"]),
        name = branchMap["branchName"],
        lat = double.parse(branchMap["latitude"]),
        lon = double.parse(branchMap["longtitue"]),
        address = branchMap["address"],
        type = branchMap["type"],
        img = branchMap["img"],
        timeTable = branchMap["timeTable"],
        state = branchMap["door"];
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
