import 'dart:convert';

import 'package:ddish/src/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:ddish/src/repositiories/globals.dart' as globals;

class ProductRepository {
  final client = globals.client;

  Future<List<Product>> getProducts() async {
    Map<String, dynamic> response = await _requestJson("productList");
    return List<Product>.from(
        response["productList"].map((product) => Product.fromJson(product)));
  }

  Future<List<Product>> getUpgradableProducts(String productId) async {
    assert(productId != null || !productId.isEmpty);
    Map<String, dynamic> response =
        await _requestJson("upgradeProduct/$productId");

    return List<UpProduct>.from(
        response["upProducts"].map((product) => UpProduct.fromJson(product)));
  }
  Future<List<Product>> getAdditionalProducts(String productId) async {
    assert(productId != null || !productId.isEmpty);
    Map<String, dynamic> response =
    await _requestJson("productList/$productId");
    return List<Product>.from(
        response["additionalProducts"].map((product) => Product.fromJson(product)));
  }

  Future<Map<String, dynamic>> _requestJson(param) async {
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
