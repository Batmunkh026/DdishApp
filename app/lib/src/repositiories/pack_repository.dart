import 'package:ddish/src/api/pack_api_provider.dart';
import 'package:ddish/src/api/user_api_provider.dart';
import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/month_price.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/product.dart';

class PackRepository{
  var packApiProvider = PackApiProvider();
  var userApiProvider = UserApiProvider();

  //demo data
  List<Pack> packs = [
    Pack(
        Product(productName: "Энгийн багц",
        endDate:DateTime.now(),
        productId: "1"),
        [
          MonthAndPriceToExtend(1, 14900),
          MonthAndPriceToExtend(2, 25700),
          MonthAndPriceToExtend(3, 44700),
          MonthAndPriceToExtend(6, 89400),
          MonthAndPriceToExtend(12, 100000),
        ]),
    Pack(
        Product(productName: "Үлэмж багц",
            endDate:DateTime.now(),
            productId: "1"),
        [
          MonthAndPriceToExtend(1, 24900),
          MonthAndPriceToExtend(2, 35700),
          MonthAndPriceToExtend(3, 54700),
          MonthAndPriceToExtend(6, 89400),
          MonthAndPriceToExtend(12, 110000),
        ]),
    Pack(
        Product(productName: "Илүү багц",
            endDate:DateTime.now(),
            productId: "1"),
        [
          MonthAndPriceToExtend(1, 34900),
          MonthAndPriceToExtend(2, 45700),
          MonthAndPriceToExtend(3, 54700),
          MonthAndPriceToExtend(6, 99400),
          MonthAndPriceToExtend(12, 140000),
        ]),
  ];
  List<Channel> channels = [
    Channel(
        "Суваг 1",
        DateTime.now(),
        "https://bcassetcdn.com/asset/logo/d649b6be-aaef-4b9e-9413-48b6a3eb4081/logo?v=4&text=Logo+Text+Here",
        [
          MonthAndPriceToExtend(1, 7900),
          MonthAndPriceToExtend(2, 20000),
          MonthAndPriceToExtend(3, 30000),
          MonthAndPriceToExtend(6, 40000),
          MonthAndPriceToExtend(12, 50000)
        ]),
    Channel(
        "Суваг 2",
        DateTime.now(),
        "https://fbcd.co/product-lg/16a0f903bf78c3bdc5366f285609ad17_resize.jpg",
        [
          MonthAndPriceToExtend(1, 7900),
          MonthAndPriceToExtend(2, 20000),
          MonthAndPriceToExtend(3, 30000),
          MonthAndPriceToExtend(6, 40000),
          MonthAndPriceToExtend(12, 50000)
        ]),
    Channel(
        "Суваг 3",
        DateTime.now(),
        "https://cmkt-image-prd.global.ssl.fastly.net/0.1.0/ps/192693/580/386/m1/fpnw/wm0/kidz-tv-logo-preview-02-.png?1411673876&s=bcfc8640e02122416dcf0efa64849a00",
        [
          MonthAndPriceToExtend(1, 7900),
          MonthAndPriceToExtend(2, 20000),
          MonthAndPriceToExtend(3, 30000),
          MonthAndPriceToExtend(6, 40000),
          MonthAndPriceToExtend(12, 50000)
        ]),
  ];

  Future<List<Pack>> getPacks(){
    return packApiProvider.fetchPacks();
  }
  Future<List<Channel>> getChannels(){
    return packApiProvider.fetchChannels();
  }
}