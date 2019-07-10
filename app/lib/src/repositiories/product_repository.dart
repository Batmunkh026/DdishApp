import 'dart:convert';

import 'package:ddish/src/blocs/service/product/product_state.dart';
import 'package:ddish/src/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:ddish/src/repositiories/globals.dart' as globals;

class ProductRepository {
  final client = globals.client;

  Future<List<Product>> getProducts() async {
    Map<String, dynamic> response = await _requestJson("productList");
    return response["isSuccess"]
        ? List<Product>.from(response["productList"]
            .map((product) => Product.fromJson(product))) : [];
  }

  Future<List<Product>> getUpgradableProducts(String productId) async {
    assert(productId != null || !productId.isEmpty);
    Map<String, dynamic> response =
        await _requestJson("upgradeProduct/$productId");

    return response["isSuccess"]
        ? List<UpProduct>.from(response["upProducts"]
            .map((product) => UpProduct.fromJson(product))) : [];
  }

  ///хэрэв хэрэглэгч дурын сонголтоор сараа оруулсан бол
  ///ахиулах багцын үнийн дүнг бодуулах
  ///
  /// currentProduct - хэрэглэгчийн идэвхитэй багц
  /// productToExtend - ахиулах багц
  /// monthToExtend - ахиулах багцын хугацаа
  ///
  /// тухайн багцыг ахиулахад төлөх дүн [String]
  Future<String> getUpgradePrice(Product currentProduct,
      UpProduct productToExtend, int monthToExtend) async {
    assert(currentProduct != null && productToExtend != null);

    Price priceObj = productToExtend.prices
        .firstWhere((p) => p.month == monthToExtend, orElse: () => null);

    //хэрэглэгчийн оруулсан утга ахиулах багцын стандарт сарын утгатай ижил бол ахиулах багцын мэдээллээр бодож буцаах
    if (priceObj != null) return "${priceObj.month * priceObj.price}";

    Map<String, dynamic> response = await _requestJson(
        "upgradeProduct/${currentProduct.id}/$monthToExtend/${productToExtend.id}");

    //TODO үр дүнг амжилтгүй бол???
    return response["isSuccess"] ? response["priceInfo"]["price"] : "";
  }

  //Сунгах, Нэмэлт суваг
  Future<ProductPaymentState> chargeProduct(ProductPaymentState state) async {
    assert(state.selectedProduct != null);

    var _param = "chargeProduct/${state.selectedProduct.id}/${state.monthToExtend}";

    var _resultState = await productPayment(state, _param);

    return _resultState;
  }

  ///Багц ахиулах
  Future<ProductPaymentState> extendProduct(ProductPaymentState state) async {
    Product current = state.selectedProduct;
    Product toExtend = state.productToExtend;

    assert(current != null || toExtend != null);

    var _param = "upgradeProduct/${current.id}/${state.monthToExtend}/${state.priceToExtend}/${toExtend.id}";

    var _resultState = await productPayment(state, _param);

    return _resultState;
  }
  Future<ProductPaymentState> productPayment(state, param)async{
    Map<String, dynamic> response = await _requestJson(param);

    state.isSuccess = response['isSuccess'];
    state.resultMessage = response['resultMessage'];

    return state;
  }

  Future<List<Product>> getAdditionalProducts(String productId) async {
    assert(productId != null || !productId.isEmpty);
    Map<String, dynamic> response =
        await _requestJson("productList/$productId");

    return response["isSuccess"]
        ? List<Product>.from(response["additionalProducts"]
            .map((product) => Product.fromJson(product))) : [];
  }

  Future<Map<String, dynamic>> _requestJson(param) async {
    try {
      final _response = await client.read('${globals.serverEndpoint}/$param');
      var _productReponse = json.decode(_response) as Map;

      print(
          "isSuccess: ${_productReponse["isSuccess"]},  result message: ${_productReponse["resultMessage"]}");
      return _productReponse;
    } on http.ClientException catch (e) {
      // TODO catch SocketException
      throw (e);
    }
  }
}
