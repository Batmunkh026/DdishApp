import 'package:ddish/src/models/branch.dart';
import 'package:ddish/src/models/order.dart';
import 'package:ddish/src/models/result.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'dart:io';
import 'dart:convert';

class MenuRepository {
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

  Future<List<Branch>> fetchBranches() async {
    try {
      final _response = await http
          .read('${globals.serverEndpoint}/getSalesCenter', headers: {
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
}
