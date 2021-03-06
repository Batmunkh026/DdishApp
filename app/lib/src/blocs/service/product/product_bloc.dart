import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/blocs/service/product/product_event.dart';
import 'package:ddish/src/blocs/service/product/product_state.dart';
import 'package:ddish/src/models/product.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:ddish/src/models/user.dart';
import 'package:ddish/src/repositiories/product_repository.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:logging/logging.dart';

class ProductBloc extends AbstractBloc<ProductEvent, ProductState> {
  final Logger log = new Logger('ProductBloc');
  ProductRepository _productRepository;
  var _userRepository;

  ProductBloc(pageState) : super(pageState) {
    _productRepository = ProductRepository(this);
    _userRepository = UserRepository(this);
  }

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
  ProductState get initialState => Started(ProductTabType.EXTEND);

  initialize() {
    productStream = _productRepository.getProducts();

    loadInitialData()
        .listen((f) => log.info("products.length: ${products.length}"));
  }

  loadInitialData() async* {
    user = await _userRepository.getUserInformation();
    products = await productStream;

    fetchUserSelectedProduct();
    if (!products.isEmpty) dispatch(ProductTabChanged(ProductTabType.EXTEND));
  }

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductTabChanged) {
      yield Loading(event.selectedProductTabType);
      fetchUserSelectedProduct();

      if (event.selectedProductTabType == ProductTabType.ADDITIONAL_CHANNEL) {
        assert(selectedProduct != null);

        additionalProducts =
            await _productRepository.getAdditionalProducts(selectedProduct.id);

        yield ProductTabState(
            event.selectedProductTabType, selectedProduct, additionalProducts);
      } else if (event.selectedProductTabType == ProductTabType.UPGRADE) {
        assert(selectedProduct != null);
        upProducts =
            await _productRepository.getUpgradableProducts(selectedProduct.id);
        yield ProductTabState(
            event.selectedProductTabType, selectedProduct, upProducts);
      }
      //TODO
      else {
        this.products = await _productRepository.getProducts();
        yield ProductTabState(
            event.selectedProductTabType, selectedProduct, products);
      }
    } else if (event is ProductTypeSelectorClicked) {
      selectedProduct = event.selectedProduct;
      yield ProductSelectionState(
          event.selectedTab, products, event.selectedProduct);
    } else if (event is ProductItemSelected) {
      assert(event.selectedProduct != null);
      if (event.selectedTab == ProductTabType.ADDITIONAL_CHANNEL &&
          event.monthToExtend == null)
        yield AdditionalChannelState(event.selectedTab, event.selectedProduct);
      else
        yield SelectedProductPreview(event.selectedTab, event.selectedProduct,
            event.monthToExtend, event.priceToExtend);
    } else if (event is CustomProductSelected) {
      assert(event.selectedProduct != null);
      yield CustomProductSelector(event.selectedTab, event.selectedProduct,
          event.priceToExtend, products);
    } else if (event is PreviewSelectedProduct) {
      yield SelectedProductPreview(event.selectedTab, event.selectedProduct,
          event.monthToExtend, event.priceToExtend);
    } else if (event is ExtendSelectedProduct) {
      yield Loading(event.selectedTab);
//      //TODO төлбөр төлөлт хийх
      Product productToExtend = event.selectedProduct;
      ProductPaymentState state = ProductPaymentState(
          event.selectedTab,
          this.selectedProduct,
          productToExtend,
          event.extendPrice,
          event.extendMonth);

      ProductPaymentState resultState =
          await (event.selectedTab == ProductTabType.UPGRADE
              ? _productRepository.extendProduct(state)
              : _productRepository.chargeProduct(state));

      if (resultState.isSuccess) await updateUserData(event);

      yield resultState;
    } else if (event is BackToPrevState) {
      yield currentState.prevStates.last;
    }

    if (!(event is BackToPrevState)) {
      backState = beforeState;

      //ижил таб дотор шилжиж байвал өмнөх state ын түүхийг цуглуулах
      if (backState != null &&
          beforeState != null &&
          currentState.selectedProductTab == backState.selectedProductTab &&
          beforeState.selectedProductTab == currentState.selectedProductTab) {
        if (backState.prevStates.isNotEmpty)
          currentState.prevStates.addAll(backState.prevStates);

        if (!(backState is ProductPaymentState ||
            backState is SelectedProductPreview))
          currentState.prevStates.add(backState);
      } else //өөр таб руу шилжиж байгаа бол цэвэрлэх
        currentState.prevStates.clear();
    }
    if (!(event is Loading ||
            event is ProductStarted ||
            event is ExtendSelectedProduct ||
            event is PreviewSelectedProduct) &&
        beforeState != currentState) {
      log.info(
          "state changing : before = $beforeState  ,  current = $currentState ");
      beforeState = currentState;
      beforeEvent = event;
    }
  }

  ///буцаах утга нь null байж болно [хэрэглэгчид сонгосон багц байхгүй бол? ]
  DateTime getExpireDateOfUserSelectedProduct() {
    if (user == null) return null;
    var activeProduct = user.activeProducts.lastWhere(
        (p) => p.isMain && selectedProduct.id == p.id,
        orElse: () => null);
    return activeProduct == null ? null : activeProduct.expireDate;
  }

  void fetchUserSelectedProduct() {
    if (products.isEmpty) return;
    //хэрэглэгчийн идэвхтэй бүтээгдэхүүнийг авах
    selectedProduct = getUserActiveProduct();
  }

  Product getUserActiveProduct() {
    return products.lastWhere(
        (p) =>
            user.activeProducts.singleWhere((up) => up.isMain && p.id == up.id,
                orElse: () => null) !=
            null,
        orElse: () => products.first);
  }

  void updateUserData(event) async {
    user = await _userRepository.getUserInformation();

    if (event.selectedTab == ProductTabType.ADDITIONAL_CHANNEL)
      additionalProducts =
          await _productRepository.getAdditionalProducts(selectedProduct.id);
    else
      upProducts =
          await _productRepository.getUpgradableProducts(selectedProduct.id);

    fetchUserSelectedProduct();
  }

  backToPrevState() =>
      dispatch(BackToPrevState(currentState.selectedProductTab));
}
