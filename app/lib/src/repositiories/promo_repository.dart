import 'dart:io';
import 'package:ddish/src/models/promo.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'dart:convert';

class PromoRepository{

  Future<List> fetchNewPromorion() async {
    List<NewPromoMdl> promos = List<NewPromoMdl>();
    try{
      var response;
      response = await http.read('${globals.serverEndpoint}/newPromotion',
          headers: {
            HttpHeaders.authorizationHeader: globals.authorizationToken
          });
      var decoded = json.decode(response);
      if(decoded['isSuccess']){
        promos = List<NewPromoMdl>.from(
            decoded['promotions'].map((promoMdl) => NewPromoMdl.fromJson(promoMdl)));
      }
      else{
        promos = null;
      }
      return promos;
    } on Exception catch(e){
      //debugPrint(e.toString());
      throw(e);
    }

  }

}

class AntennRepository{
  Future<List> fetchAntenna() async{
    List<AntennMdl> manuals = List<AntennMdl>();
    try{
      var response;
      response = await http.read('${globals.serverEndpoint}/newPromotion/0',
          headers: {
            HttpHeaders.authorizationHeader: globals.authorizationToken
          });
      var decoded = json.decode(response);
      if(decoded['isSuccess']){
        manuals = List<AntennMdl>.from(
            decoded['manuals'].map((antennMdl) => AntennMdl.fromJson(antennMdl)));
      }
      else{
        manuals = null;
      }
      return manuals;
    }on Exception catch(e){
      //debugPrint(e.toString());
      throw(e);
    }
  }
}

class AntennVideoRepository{
  Future<List> fetchAntennaVideo() async{
    List<AntennVideoMdl> vimanuals = List<AntennVideoMdl>();
    try{
      var response;
      response = await http.read('${globals.serverEndpoint}/newPromotion/0/0',
          headers: {
            HttpHeaders.authorizationHeader: globals.authorizationToken
          });
      var decoded = json.decode(response);
      if(decoded['isSuccess']){
        vimanuals = List<AntennVideoMdl>.from(
            decoded['videoManuals'].map((antennVideoMdl) => AntennVideoMdl.fromJson(antennVideoMdl)));
      }
      else{
        vimanuals = null;
      }
      return vimanuals;
    }on Exception catch(e){
      //debugPrint(e.toString());
      throw(e);
    }
  }
}