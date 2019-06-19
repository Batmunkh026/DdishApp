import 'dart:convert';

import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:ddish/src/repositiories/globals.dart' as globals;

class ProductRepository {
  final client = globals.client;

  Future<List<Product>> getProducts() async {
    Map<String, dynamic> response = await requestJson("productList");
    return List<Product>.from(
        response["productList"].map((product) => Product.fromJson(product)));
  }

  Future<List<Product>> getUpgradableProducts(String productId) async {
    assert(productId != null || !productId.isEmpty);
    Map<String, dynamic> response =
        await requestJson("productList/$productId");
    return List<Product>.from(
        response["upProducts"].map((product) => Product.fromJson(product)));
  }

  Future<Map<String, dynamic>> requestJson(param) async {
    try {
      final _response = await client.read('${globals.serverEndpoint}/$param');
      var _productReponse = json.decode(_response) as Map;

      return _productReponse["isSuccess"] ? _productReponse : [];
    } on http.ClientException catch (e) {
      // TODO catch SocketException
      throw (e);
    }
  }
}
