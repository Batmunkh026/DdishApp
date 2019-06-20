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
  BranchArea city;
  BranchType type;
  String state;
  BranchService service;

  get cityCode => city == null ? null : city.code;

  get typeCode => type == null ? null : type.code;

  get serviceCode => service == null ? null : service.code;

  BranchFilter(this.city, this.type, this.state, this.service);
}

class BranchParam {
  List<BranchArea> branchAreas;
  List<BranchType> branchTypes;
  List<BranchService> branchServices;

  BranchParam(@required this.branchAreas, @required this.branchTypes,
      @required this.branchServices)
      : assert(branchAreas != null),
        assert(branchTypes != null),
        assert(branchServices != null);
}

class BranchArea {
  String name;
  String code;

  BranchArea.fromMap(Map<String, dynamic> map)
      : name = map['areaName'],
        code = map['areaCode'];
}

class BranchType {
  String name;
  String code;

  BranchType.fromMap(Map<String, dynamic> map)
      : name = map['typeName'],
        code = map['typeCode'];
}

class BranchService {
  String name;
  String code;

  BranchService.fromMap(Map<String, dynamic> map)
      : name = map['serviceName'],
        code = map['serviceCode'];
}
