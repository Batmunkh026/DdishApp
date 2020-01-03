import 'package:ddish/src/blocs/service/product/product_bloc.dart';
import 'package:ddish/src/blocs/service/product/product_state.dart';
import 'package:ddish/src/models/product.dart';
import 'abstract_repository.dart';

class ProductRepository extends AbstractRepository<ProductBloc> {
  ProductRepository(ProductBloc bloc) : super(bloc);

  /// Бүтээгдэхүүний мэдээллүүдийг авах
  Future<List<Product>> getProducts() async {
    Map<String, dynamic> response = await _requestJson("productList");
    return response["isSuccess"]
        ? List<Product>.from(
            response["productList"].map((product) => Product.fromJson(product)))
        : [];
  }

  /// Ахиулах боломжтой бүтээгдэхүүнүүдийг авах
  Future<List<Product>> getUpgradableProducts(String productId) async {
    assert(productId != null || !productId.isEmpty);
    Map<String, dynamic> response =
        await _requestJson("upgradeProductNew/$productId");

    var ps =
        response["upProducts"].map((product) => UpProduct.fromJson(product));

    return response["isSuccess"] ? List<UpProduct>.from(ps) : List();
  }

  ///хэрэв хэрэглэгч дурын сонголтоор сараа оруулсан бол
  ///ахиулах багцын үнийн дүнг бодуулах
  ///
  /// currentProduct - хэрэглэгчийн идэвхитэй багц
  /// productToExtend - ахиулах багц
  /// monthToExtend - ахиулах багцын хугацаа
  ///
  /// тухайн багцыг ахиулахад төлөх дүн [String]
//  Future<String> getUpgradePrice(Product currentProduct,
//      UpProduct productToExtend, int monthToExtend) async {
//    assert(currentProduct != null && productToExtend != null);
//
//    Price priceObj = productToExtend.prices
//        .firstWhere((p) => p.month == monthToExtend, orElse: () => null);
//
//    //хэрэглэгчийн оруулсан утга ахиулах багцын стандарт сарын утгатай ижил бол ахиулах багцын мэдээллээр бодож буцаах
//    if (priceObj != null) return "${priceObj.price}";
//
//    Map<String, dynamic> response = await _requestJson(
//        "upgradeProduct/${currentProduct.id}/$monthToExtend/${productToExtend.id}");
//
//    //TODO үр дүнг амжилтгүй бол???
//    return response["isSuccess"] ? response["priceInfo"]["price"] : "";
//  }

  //Сунгах, Нэмэлт суваг
  Future<ProductPaymentState> chargeProduct(ProductPaymentState state) async {
    assert(state.selectedProduct != null);

    var _param =
        "chargeProduct/${state.selectedProduct.id}/${state.monthToExtend}";

    var _resultState = await productPayment(state, _param);

    return _resultState;
  }

  ///Багц ахиулах хүсэлт илгээх
  Future<ProductPaymentState> extendProduct(ProductPaymentState state) async {
    Product current = state.selectedProduct;
    Product toExtend = state.productToExtend;

    assert(current != null || toExtend != null);

    var _param = "upgradeProductNew/${toExtend.id}/yes";

    var _resultState = await productPayment(state, _param);

    return _resultState;
  }

  /// Багц ахиулалтын төлбөр төлөлт
  Future<ProductPaymentState> productPayment(state, param) async {
    Map<String, dynamic> response = await _requestJson(param);

    state.isSuccess = response['isSuccess'];
    state.resultMessage = response['resultMessage'];

    return state;
  }

  /// Нэмэлт бүтээгдэхүүнүүдийг авах
  Future<List<Product>> getAdditionalProducts(String productId) async {
    assert(productId != null || !productId.isEmpty);
    Map<String, dynamic> response =
        await _requestJson("productList/$productId");

    return response["isSuccess"]
        ? List<Product>.from(response["additionalProducts"]
            .map((product) => Product.fromJson(product)))
        : [];
  }

  /// ерөнхий http хүсэлт илгээх
  Future<Map<String, dynamic>> _requestJson(param) async {
    return await getResponse(param) as Map;
  }
}
