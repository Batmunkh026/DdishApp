import 'dart:convert';

import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'abstract_repository.dart';

class VodRepository extends AbstractRepository {
  VodRepository(AbstractBloc bloc) : super(bloc);

  Future<List> fetchVodChannels() async {
    var decoded = await getResponse('vodList');
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
    var cached = await prefs.getString(cacheKey);

    if (cached != null) {
      response = cached;
    } else {
      response = await getResponse(
          'vodList/${channel.productId}/${DateUtil.formatParamDate(date)}',
          hasDecoded: false);
      if(Result.fromJson(jsonDecode(response)).isSuccess)
        await prefs.setString(cacheKey, response.toString());
      else
        return List<Program>.from([]);
    }

    var decoded = json.decode(response);
    List<Program> programList = List<Program>.from(
        decoded['programList'].map((program) => Program.fromJson(program)));
    // TODO handle isSuccess = false
    return programList;
  }

  Future<Movie> fetchContentDetails(Program program) async {
    var decoded = await getResponse('vodList/${program.contentId}');
    return Movie.fromJson(decoded);
  }

  Future<Result> chargeProduct(Program program) async {
    var decoded = await getResponse(
        'chargeProduct/${program.productId}/${program.smsCode}/${DateUtil.formatParamDate(program.beginDate)}');
    return Result.fromJson(decoded);
  }

  Future<List> fetchPushVod() async {
    var decoded = await getResponse('pushVod');
    var posterUrls = List<String>.from(
        decoded['contents'].map((map) => map['contentImgUrl']));
    return posterUrls;
  }

  Future<Result> rentContent(int id) async {
    var decoded = await getResponse('pushVod/$id');
    return Result.fromJson(decoded);
  }

  Future<List> searchProgram(String value, int page) async {
    var decoded = await getResponse(
        'searchVodContent/$value/0?pageNumber=${(page / 10 + 1).toInt()}');
    Result result = Result.fromJson(decoded);
    List<Program> programList = [];
    if (result.isSuccess)
      programList = List<Program>.from(
          decoded['programList'].map((program) => Program.fromJson(program)));
    // TODO handle isSuccess = false
    return programList;
  }

  ///өгөгдсөн ID кино байгаа эсэхийг шалгах
  Future<bool> isValidMovieId(String movieId) async {
    var decoded = await getResponse('searchArVod/$movieId');
    Result result = Result.fromJson(decoded);
    log.info("isValidMovieID : $result");
    return result.isSuccess;
  }
}
