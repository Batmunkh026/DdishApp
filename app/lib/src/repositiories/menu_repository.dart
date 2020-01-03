import 'package:ddish/src/models/branch.dart';
import 'package:ddish/src/models/order.dart';
import 'package:ddish/src/models/result.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'dart:io';
import 'dart:convert';

class MenuRepository {
  /// захиалга илгээх
  Future<Result> postOrder(Order order) async {
    var response;
    try {
      response = await http.read(
        '${globals.serverEndpoint}/newOrder/${order.toString()}',
        headers: {HttpHeaders.authorizationHeader: globals.authorizationToken},
      );
    } on Exception catch (e) {
      throw (e);
    }
    var decoded = json.decode(response);
    Result result = Result.fromJson(decoded);
    return result;
  }

  /// Салбарын мэдээллүүдийг авах
  Future<List<Branch>> fetchBranches(area, type, service) async {
    try {
      var params = _collectParams(area, type, service);
      final _response = await http.read(
          '${globals.serverEndpoint}/getSalesCenter' +
              params,
          headers: {
            HttpHeaders.authorizationHeader: globals.authorizationToken
          });
      var _branchReponse = json.decode(_response) as Map;

      if (_branchReponse["isSuccess"])
        return List<Branch>.from(_branchReponse["salesCenters"]
            .map((branch) => Branch.fromJson(branch)));
      return [];
    } on http.ClientException catch (e) {
      // TODO catch SocketException
      throw (e);
    }
  }

  /// салбарын шүүлтүүрийн мэдээллүүдийг авах
  Future<BranchParam> fetchBranchParams() async {
    try {
      final _response = await http
          .read('${globals.serverEndpoint}/getSalesCenter', headers: {
        HttpHeaders.authorizationHeader: globals.authorizationToken
      });
      var _branchReponse = json.decode(_response) as Map;

      if (_branchReponse["isSuccess"]) {
        List<BranchArea> areas = List<BranchArea>.from(
            _branchReponse["branchAreas"]
                .map((branchArea) => BranchArea.fromMap(branchArea)));

        List<BranchType> types = List<BranchType>.from(
            _branchReponse["branchTypes"]
                .map((branchType) => BranchType.fromMap(branchType)));

        List<BranchService> services = List<BranchService>.from(
            _branchReponse["branchServices"]
                .map((branchService) => BranchService.fromMap(branchService)));

        return BranchParam(areas, types, services);
      }
      return null;
    } on http.ClientException catch (e) {
      // TODO catch SocketException
      throw (e);
    }
  }

  ///салбарын шүүлтүүрийн мэдээллүүдийг цуглуулах
  String _collectParams(area, type, service) =>
      _createParam(area) + _createParam(type) + _createParam(service);

  String _createParam(String param) =>
      param == null || param.isEmpty ? "/all" : "/$param";
}
