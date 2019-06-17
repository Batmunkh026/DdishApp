import 'package:ddish/src/api/pack_api_provider.dart';
import 'package:ddish/src/api/user_api_provider.dart';
import 'package:ddish/src/models/channel.dart';
import 'package:ddish/src/models/pack.dart';

class PackRepository{
  var packApiProvider = PackApiProvider();
  var userApiProvider = UserApiProvider();

  Future<List<Pack>> getPacks(){
    return packApiProvider.fetchPacks();
  }
  Future<List<Channel>> getChannels(String productId){
    return packApiProvider.fetchChannels(productId);
  }

  Future<List<Pack>> getPacksToUpgrade(String productId) {
    return packApiProvider.fetchPacksToUpgrade(productId);
  }
}