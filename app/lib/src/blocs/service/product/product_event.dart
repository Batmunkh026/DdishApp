import 'dart:collection';

import 'package:ddish/src/models/product.dart';
import 'package:ddish/src/models/tab_models.dart';
import 'package:equatable/equatable.dart';

import 'product_state.dart';

abstract class ProductEvent extends Equatable {
  ProductTabType selectedTab;
  ProductEvent(this.selectedTab, [List props = const []]) : super(props);
}
///Сунгах багцуудыг төрлөөр нь сонгох үед дуудагдах эвент
///
/// parameter:
///
/// __selectedPack__ - сонгогдсон багцын төрөл
class ProductTypeSelectorClicked extends ProductEvent {
  Product
      selectedProduct; //TODO багцын төрлийг баазаас авах шаардлагагүй бол enum төрлөөр шийдэх, үгүй бол багцын төрлийг өөрчлөх
  ProductTypeSelectorClicked(ProductTabType selectedProductTabType, this.selectedProduct)
      : assert(selectedProduct != null),
        super(selectedProductTabType, [selectedProductTabType, selectedProduct]);
}

///#Багцын дэд үйлчилгээ сонгогдсон эвент
///
/// **жишээ:**
/// Хэрэв __багц сунгах__ эсвэл __нэмэлт суваг__ табуудаас аль нэгийг сонгосон тохиолдолд энэ эвент дуудах
class ProductTabChanged extends ProductEvent {
  ProductTabType selectedProductTabType;
  ProductTabChanged(this.selectedProductTabType)
      : super(selectedProductTabType, [selectedProductTabType]);
}

// тухайн багцын хугацаа&төлбөр сонгох
//  сонгогдсон элемент нь null байвал <өөр сонголт хийх> оролдлого гэж ойлгох
class ProductItemSelected extends ProductEvent {
  Product selectedProduct;
  int monthToExtend;

  ProductItemSelected(
      ProductTabType selectedProductTabType, Product this.selectedProduct, this.monthToExtend)
      : super(selectedProductTabType,
            [selectedProductTabType, monthToExtend, selectedProduct]);
}

///Өөр дүн оруулах
class CustomProductSelected extends ProductEvent {
  Product selectedProduct;
  int monthToExtend;

  CustomProductSelected(selectedProductTabType,Product this.selectedProduct, this.monthToExtend)
      : super(selectedProductTabType,
            [selectedProductTabType, selectedProduct, monthToExtend]);
}

//
//Сонгогдсон багцын сунгалтын өмнөх төлвийг харах
class PreviewSelectedProduct extends ProductEvent {
  Product selectedProduct;
  int monthToExtend;

  PreviewSelectedProduct(
      ProductTabType selectedProductTab, Product this.selectedProduct, this.monthToExtend)
      : super(selectedProductTab, [selectedProductTab, monthToExtend]);
}

//Сонгогдсон багцын сунгах
class ExtendSelectedProduct extends ProductEvent {
  Product selectedProduct;
  int extendMonth;
  ExtendSelectedProduct(
      ProductTabType selectedProductTab, Product this.selectedProduct, this.extendMonth)
      : super(selectedProductTab, [selectedProductTab]);
}

class BackToPrevState extends ProductEvent {
  ListQueue<ProductState>
      states; //TODO state үүдийн stack үүсгээд буцах дарах үед сүүлийн state үүдийг устгаад явах
  BackToPrevState(ProductTabType selectedTab) : super(selectedTab, [selectedTab]);
}
