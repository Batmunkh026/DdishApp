import 'dart:convert';

import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;

class VodRepository {
  final client = globals.client;

  Future<List> fetchVodChannels() async {
    var response;
    try {
      response = await client.read('${globals.serverEndpoint}/vodList');
    } on Exception catch (e) {
      // TODO catch SocketException
      throw (e);
    }
    var decoded = json.decode(response);
    List<VodChannel> vodChannels = List<VodChannel>.from(
        decoded['vodChannels'].map((channel) => VodChannel.fromJson(channel)));
    // TODO handle isSuccess = false
    return vodChannels;
  }

  Future<List> fetchProgramList(VodChannel channel, {DateTime date}) async {
    var response;
    date = date == null ? DateTime.now() : date;
    String cacheKey = '${channel.productId}/${DateUtil.formatParamDate(date)}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cached = prefs.getString(cacheKey);
    if (cached != null) {
      response = cached;
    } else {
      try {
        response = await client.read(
            '${globals.serverEndpoint}/vodList/${channel.productId}/${DateUtil.formatParamDate(date)}');
      } on Exception catch (e) {
        // TODO catch SocketException
        throw (e);
      }
      await prefs.setString(cacheKey, response.toString());
    }

    var decoded = json.decode(response);
    List<Program> programList = List<Program>.from(
        decoded['programList'].map((program) => Program.fromJson(program)));
    // TODO handle isSuccess = false
    return programList;
  }

  Future<Movie> fetchContentDetails(Program program) async {
    var response;
    try {
      response = await globals.client
          .read('${globals.serverEndpoint}/vodList/${program.contentId}');
    } on Exception catch (e) {
      throw (e);
    }

    var decoded = json.decode(response);
    return Movie.fromJson(decoded);
  }

  Future<Result> chargeProduct(Program program) async {
    var response;
    try {
      response = await globals.client.read(
          '${globals.serverEndpoint}/chargeProduct/${program.productId}/${program.smsCode}/${DateUtil.formatParamDate(program.beginDate)}');
    } on Exception catch (e) {
      throw (e);
    }

    var decoded = json.decode(response);
    return Result.fromJson(decoded);
  }

  Future<List> fetchPushVod() async {
    var response;
    try {
      response = await globals.client.read('${globals.serverEndpoint}/pushVod');
    } on Exception catch (e) {
      throw (e);
    }

    var decoded = json.decode(response);
    var posterUrls = List<String>.from(
        decoded['contents'].map((map) => map['contentImgUrl']));
    return posterUrls;
  }

  Future<Result> rentContent(int id) async {
    var response;
    try {
      response =
          await globals.client.read('${globals.serverEndpoint}/pushVod/$id');
    } on Exception catch (e) {
      throw (e);
    }

    var decoded = json.decode(response);
    return Result.fromJson(decoded);
  }

  Future<List> searchProgram(String value) async {
    var response;
    try {
      response = await client.read('${globals.serverEndpoint}/vodList/$value?res=0');
    } on Exception catch (e) {
      // TODO catch SocketException
      throw (e);
    }

    var decoded = json.decode(response);
    Result result = Result.fromJson(decoded);
    List<Program> programList;
    if (result.isSuccess)
      programList = List<Program>.from(
          decoded['programList'].map((program) => Program.fromJson(program)));
    // TODO handle isSuccess = false
    return programList;
  }
}
