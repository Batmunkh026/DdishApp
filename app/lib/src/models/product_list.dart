import 'package:ddish/src/models/product.dart';

class ProductList {
  final List<Product> products;

  ProductList({this.products});

  factory ProductList.fromJson(List<dynamic> parsedJson) {
    List<Product> activeProducts = parsedJson.map((i) => Product.fromJson(i)).toList();
    return ProductList(
      products: activeProducts,
    );
  }
}
