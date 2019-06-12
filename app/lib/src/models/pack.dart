import 'month_price.dart';
import 'product.dart';
import 'dart:convert';

///Багц
class Pack {
  final Product product;

//  сарын багцууд
  final List<MonthAndPriceToExtend> packsForMonth;

  Pack(this.product, this.packsForMonth)
      : assert(product != null),
        assert(packsForMonth != null);

  Pack.fromJson(Map<String, dynamic> packMap)
      : product = packMap['name'],
        packsForMonth = (json.decode(packMap["packs"]) as List).map((v)=>MonthAndPriceToExtend.fromJson(v)).toList();
}
