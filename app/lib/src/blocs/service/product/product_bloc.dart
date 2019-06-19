import 'package:bloc/bloc.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/blocs/service/product/product_state.dart';
import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/product.dart';
import 'package:ddish/src/models/payment_state.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/models/user.dart';
import 'package:ddish/src/repositiories/product_repository.dart';
import 'package:ddish/src/repositiories/user_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  var productRepository = ProductRepository();
  var _userRepository = UserRepository();

  ProductEvent beforeEvent = null;
  ProductState beforeState = null;
  ProductState backState = null;

  List<Product> products;
  List<Product> additionalProducts;
  List<Product> upProducts;

  Product selectedProduct;
  User user;
  Future<List<Product>> productStream; //TODO API аас авдаг болсон үед ашиглана

  @override
  ProductState get initialState {
    productStream = productRepository.getProducts();

    ///fetch хийж дууссан бол
    loadInitialData().listen((f) => print("initial data loaded."));

    return Loading(ProductTabType.EXTEND);
  }

  loadInitialData() async* {
    user = await _userRepository.getUserInformation();

    products = await productStream;

    //хэрэглэгчийн идэвхтэй бүтээгдэхүүнийг авах
    //байхгүй бол products.first
    selectedProduct = products.firstWhere(
        (p) =>
            user.activeProducts.singleWhere((up) => up.isMain && p.id == up.id,
                orElse: () => null) !=
            null,
        orElse: () => products.first);

    dispatch(ProductTabChanged(ProductTabType.EXTEND));
  }

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductTabChanged) {
      yield Loading(event.selectedProductTabType);

      if (event.selectedProductTabType == ProductTabType.ADDITIONAL_CHANNEL) {
        this.additionalProducts = await user.additionalProducts;
        yield ProductTabState(event.selectedProductTabType, additionalProducts);
      } else if (event.selectedProductTabType == ProductTabType.UPGRADE) {
        assert(selectedProduct != null);
        this.upProducts =
            await productRepository.getUpgradableProducts(selectedProduct.id);
        yield ProductTabState(event.selectedProductTabType, upProducts);
      }
      //TODO
      else {
        this.products = await productRepository.getProducts();
        yield ProductTabState(event.selectedProductTabType, products);
      }
    } else if (event is ProductTypeSelectorClicked) {
      //багцын төрөл сонгосон үед
      //Багц сунгах төлөв бол тухайн багцын төрөлд хамаарах багцуудыг шүүж харуулах
      //TODO нэмэлт сувгуудад багцын төрөл хамаатай эсэхийг тодруулах
      yield ProductSelectionState(
          event.selectedTab, products, event.selectedProduct);
    } else if (event is ChannelSelected) {
      yield AdditionalChannelState(event.selectedTab, event.selectedProduct);
    } else if (event is ProductItemSelected) {
      //багц сонгосон үед
      assert(event.selectedProduct != null);
      //багц сонгогдсон
      if (event.selectedTab == ProductTabType.ADDITIONAL_CHANNEL &&
          event.monthToExtend == null)
        yield AdditionalChannelState(event.selectedTab, event.selectedProduct);
      else
        yield SelectedProductPreview(
            event.selectedTab, event.selectedProduct, event.monthToExtend);
    } else if (event is CustomProductSelected) {
      assert(event.selectedProduct != null);
      yield CustomProductSelector(
          event.selectedTab, event.selectedProduct, products);
    } else if (event is PreviewSelectedProduct) {
      yield SelectedProductPreview(
          event.selectedTab, event.selectedProduct, event.monthToExtend);
    } else if (event is ExtendSelectedProduct) {
//      //TODO төлбөр төлөлт хийх
      int monthToExtend = event.extendMonth; //сунгах сар
      Product selectedProduct = event.selectedProduct;
//      TODO төлбөр төлөлтийн үр дүнг дамжуулах
      PaymentState paymentState;
      yield ProductPaymentState(
          event.selectedTab, selectedProduct, monthToExtend, paymentState);
    } else if (event is BackToPrevState) {
      yield currentState.prevStates.last;
    }

    //
    if (!(event is BackToPrevState)) {
      backState = beforeState;

      //ижил таб дотор шилжиж байвал өмнөх state ын түүхийг цуглуулах
      if (backState != null &&
          beforeState != null &&
          currentState.selectedProductTab == backState.selectedProductTab &&
          beforeState.selectedProductTab == currentState.selectedProductTab) {
        if (backState.prevStates.isNotEmpty)
          currentState.prevStates.addAll(backState.prevStates);
        currentState.prevStates.add(backState);
      } else //өөр таб руу шилжиж байгаа бол цэвэрлэх
        currentState.prevStates.clear();
    }
    if (!(event is Loading)) {
      beforeState = currentState;
      beforeEvent = event;
    }
  }

  /// Багц эсвэл нэмэлт суваг сонголт
  ///
  /// **selectedProductTab** - сонгогдсон багцын төрөл **[Үлэмж, Илүү, Энгийн, ...]**
  ///
  /// **selectedProductTab** - сонгосон багцад харгалзах дата
  ProductTabState updateProductTabState(
      ProductTabType selectedProductTab, List<dynamic> itemsForSelectedTab) {
    return ProductTabState(selectedProductTab, itemsForSelectedTab);
  }

  ///Багцын хугацааа&үнийн дүнгийн төрөл сонгох
  void selectProductItem(ProductTabType selectedProductTab, dynamic product) {
    ProductItemState(selectedProductTab, product);
  }

  ///буцаах утга нь null байж болно [хэрэглэгчид сонгосон багц байхгүй бол? ]
  DateTime getDateOfUserSelectedProduct() {
    var activeProduct =
        user.activeProducts.firstWhere((p) => p.isMain, orElse: () => null);
    return activeProduct == null ? null : activeProduct.expireDate;
  }
}
