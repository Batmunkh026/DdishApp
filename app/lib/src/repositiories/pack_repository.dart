import 'package:ddish/src/api/pack_api_provider.dart';
import 'package:ddish/src/api/user_api_provider.dart';
import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/month_price.dart';
import 'package:ddish/src/models/pack.dart';

class PackRepository{
  var packApiProvider = PackApiProvider();
  var userApiProvider = UserApiProvider();

  //demo data
  List<Pack> packs = [
    Pack(
        "Энгийн багц",
        DateTime.now(),
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYd8ogEfk_qErXUtY-ry3WBlk_IxTiEHg9xHzAaLMuhQRscRuD",
        [
          MonthAndPriceToExtend(1, 14900),
          MonthAndPriceToExtend(2, 25700),
          MonthAndPriceToExtend(3, 44700),
          MonthAndPriceToExtend(6, 89400),
          MonthAndPriceToExtend(12, 100000),
        ]),
    Pack(
        "Үлэмж багц",
        DateTime.now(),
        "https://3.bp.blogspot.com/-oVcccKo3lJ8/WVCgHndUQ8I/AAAAAAAABrA/qolfO6zcNXgUrFfYBLgsQPA63O_Ay9uegCLcBGAs/s320/Eid%2Boffer.png",
        [
          MonthAndPriceToExtend(1, 14900),
          MonthAndPriceToExtend(2, 25700),
          MonthAndPriceToExtend(3, 44700),
          MonthAndPriceToExtend(6, 89400),
          MonthAndPriceToExtend(12, 100000),
        ]),
    Pack(
        "Илүү багц",
        DateTime.now(),
        "https://cdn.iconscout.com/icon/free/png-256/valentine-valentines-day-special-offer-sale-discount-ribbon-tag-label-12958.png",
        [
          MonthAndPriceToExtend(1, 14900),
          MonthAndPriceToExtend(2, 25700),
          MonthAndPriceToExtend(3, 44700),
          MonthAndPriceToExtend(6, 89400),
          MonthAndPriceToExtend(12, 100000),
        ]),
  ];
  List<Channel> channels = [
    Channel(
        "Суваг 1",
        DateTime.now(),
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYd8ogEfk_qErXUtY-ry3WBlk_IxTiEHg9xHzAaLMuhQRscRuD",
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
        "https://3.bp.blogspot.com/-oVcccKo3lJ8/WVCgHndUQ8I/AAAAAAAABrA/qolfO6zcNXgUrFfYBLgsQPA63O_Ay9uegCLcBGAs/s320/Eid%2Boffer.png",
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
        "https://cdn.iconscout.com/icon/free/png-256/valentine-valentines-day-special-offer-sale-discount-ribbon-tag-label-12958.png",
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