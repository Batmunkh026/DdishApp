import 'package:ddish/src/models/product.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

///Багцын төлөв
abstract class ProductState extends Equatable {
  List<Product> initialItems;
  Product selectedProduct;
  ProductTabType selectedProductTab;
  Set<ProductState> prevStates = Set();

  ProductState(this.selectedProductTab, List<Product> this.initialItems,
      Product this.selectedProduct,
      [List props = const []])
      : super(props) {
    if (selectedProduct == null && initialItems.length > 0)
      selectedProduct = initialItems.first;
  }
}

class Loading extends ProductState {
  Loading(ProductTabType selectedTab) : super(selectedTab, [], null);
}

///#Багцын үйлчилгээний төрөл өөрчлөгдөх төлөв
///
///**жишээ** :
///
/// Хэрэглэгч үйлчилгээний __багц сунгах__ төлвөөс __нэмэлт сувгууд__ төлөврүү шилжих
///
/// эсвэл __нэмэлт сувгууд__ төлвөөс __багц ахиулах__ төлөврүү шилжих.
///
///__properties__:
///
/// **selectedTab** - Сонгосон багцын төлөв
///
///  **initialItems** - Сонгосон багц дахь дата;
class ProductTabState extends ProductState {
  ProductTabType selectedProductTab;
  List<Product> initialItems;

  /// parameters:
  ///
  /// **selectedTab** - сонгосон багцын үйлчилгээний төлөв
  ///
  /// **initialItems** - тухайн сонгосон багцын үйлчилгээнд харгалзах дата
  ProductTabState(@required this.selectedProductTab, selectedProduct,
      @required this.initialItems)
      : assert(selectedProductTab != null),
        assert(initialItems != null),
        super(selectedProductTab, initialItems, selectedProduct,
          [selectedProductTab]);

  @override
  String toString() => "PackTab state $selectedProductTab - $selectedProduct";
}

///нэмэлт суваг сонгогдсон төлөв
class AdditionalChannelState extends ProductState {
  Product selectedProduct;
  AdditionalChannelState(
      ProductTabType selectedProductTab, @required this.selectedProduct,
      {isReload = false})
      : assert(selectedProduct != null),
        super(selectedProductTab, null, selectedProduct,
          [selectedProductTab, selectedProduct, isReload]);
}

///Багц сонголтын төлөв
///
/// __selectedPac
class ProductSelectionState extends ProductState {
  ProductTabType selectedProductTab;
  List<Product> products;
  final Product selectedProduct;

  ProductSelectionState(
      this.selectedProductTab, this.products, @required this.selectedProduct)
      : super(selectedProductTab, products, selectedProduct,
      [selectedProductTab, products, selectedProduct]);

  @override
  String toString() => "Pack selection state $selectedProduct";
}

///нэмэлт суваг эсвэл аль нэг  багц ын хугацаа&үнийн дүнгийн төрлөөс сонгосон төлөв
///
///selectedPackItem - сонгогдсон багцын утга \null байж болно\
///
///хэрэв selectedPackItem == null бол <өөр сонголт хийх> хүсэлт гэж ойлгож сунгах сарын тоогоо оруулах цонхрүү шилжүүлэх
class ProductItemState extends ProductState {
  ///сонгогдсон tab (сунгах, нэмэлт суваг)
  ProductTabType selectedProductTab;
  Product selectedProductItem; //TODO сонгогдсон багцын төрлийг тодорхойлох

  ProductItemState(this.selectedProductTab, this.selectedProductItem)
      : super(selectedProductTab, null, selectedProductItem,
      [selectedProductTab, selectedProductItem]);
}

///нэмэлт суваг эсвэл аль нэг  багц ын хугацаа&үнийн дүнгийн төрлөөс сонгосон төлөв
///
///selectedPackItem - сонгогдсон багцын утга \null байж болно\
///
///хэрэв selectedPackItem == null бол <өөр сонголт хийх> хүсэлт гэж ойлгож сунгах сарын тоогоо оруулах цонхрүү шилжүүлэх
class SelectedProductPreview extends ProductState {
  ///сонгогдсон tab (сунгах, нэмэлт суваг)
  ProductTabType selectedProductTab;
  var selectedProduct;
  int monthToExtend;
  int priceToExtend;

  SelectedProductPreview(this.selectedProductTab, this.selectedProduct,
      this.monthToExtend, this.priceToExtend)
      : assert(selectedProduct != null),
        super(selectedProductTab, null, selectedProduct);
}

class CustomProductSelector extends ProductState {
  ///сонгогдсон tab (сунгах, нэмэлт суваг)
  var selectedProduct;
  int priceToExtend;

  CustomProductSelector(
      selectedTab, this.selectedProduct, this.priceToExtend, products)
      : super(selectedTab, products, selectedProduct,
      [selectedTab, products, selectedProduct]);

  @override
  String toString() =>
      "custom selector : $selectedProductTab: $selectedProduct";
}

///custom month value state
class CustomMonthState extends ProductState {
  Product currentProduct;
  UpProduct productToExtend;
  int monthToExtend;
  int priceToExtend;

  CustomMonthState(ProductTabType selectedTab, this.currentProduct,
      this.productToExtend, this.monthToExtend, this.priceToExtend)
      : super(selectedTab, [], productToExtend,
      [selectedTab, currentProduct, productToExtend, monthToExtend, priceToExtend]);
}

///Сонгогдсон багцын төлбөр төлөлтийн төлөв
class ProductPaymentState extends ProductState {
  Product productToExtend;
  var priceToExtend;
  int monthToExtend;
  bool isSuccess;
  String resultMessage;

  ProductPaymentState(ProductTabType selectedProductTab, selectedProduct,
      this.productToExtend, this.priceToExtend, this.monthToExtend)
      : super(selectedProductTab, [], productToExtend);
}
