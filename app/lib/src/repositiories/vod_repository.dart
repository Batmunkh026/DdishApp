import 'dart:convert';

import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/models/movie.dart';
import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/result.dart';
import 'package:ddish/src/models/vod_channel.dart';
import 'package:ddish/src/utils/date_util.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'abstract_repository.dart';

class VodRepository extends AbstractRepository {
  VodRepository(AbstractBloc bloc) : super(bloc);
  Logger _logger = Logger("VodRepository");

  Future<List> fetchVodChannels() async {
    var decoded = await getResponse('vodList');
    List<VodChannel> vodChannels = List<VodChannel>.from(
        decoded['vodChannels'].map((channel) => VodChannel.fromJson(channel)));
    // TODO handle isSuccess = false
    return vodChannels;
  }

  Future<List> fetchProgramList(VodChannel channel, {DateTime date}) async {
    var response;
    bool isToday = date == null;

    date = date == null ? DateTime.now() : date;

    String param = '${channel.productId}/${DateUtil.formatParamDate(date)}';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cached = await prefs.getString(param);

    bool isCached = cached != null;

    if (isCached) {
      response = cached;
    } else {
      response = await getResponse('vodList/$param', hasDecoded: false);
      if (Result.fromJson(jsonDecode(response)).isSuccess)
        await prefs.setString(param, response.toString());
      else
        return List<Program>.from([]);
    }

    List<Program> programList = [];
    var decoded;
    try {
      decoded = json.decode(response);
    } catch (e) {
      _logger.warning(e);
    }

    programList = List<Program>.from(
        decoded['programList'].map((program) => Program.fromJson(program)));

    if (isToday && isCached) {
      bool isUpdated = _clearOldPrograms(programList, date);
      //TODO cache лэсэн өгөгдлийг устгах эсэхийг тодруулах
//      if (isUpdated) updateCachedPrograms(prefs, param, programList);
    }

    // TODO handle isSuccess = false
    return programList;
  }

  ///цаг нь дууссан кинонуудыг цэвэрлэх
  ///
  /// хэрэв хугацаа нь дууссан киног хассан бол true үгүй бол false утга буцаана
  _clearOldPrograms(List<Program> programs, DateTime now) {
    _logger.info("Хугацаа нь дууссан програмуудыг шалгаж байна.....");
    bool isRemovedExpiredProgram = false;

    int total = programs.length;
    int counter = 0;
    programs.removeWhere((program) {
      bool isExpired = program.endDate.isBefore(now);
      if (isExpired) {
        isRemovedExpiredProgram = true;
        counter++;
        _logger.info("Хугацаа нь дууссан: $program");
      }
      return isExpired;
    });
    if (isRemovedExpiredProgram)
      _logger.warning(
          "Нийт $total програм : Үүнээс хугацаа нь дууссан $counter програмыг устгалаа");

    return isRemovedExpiredProgram;
  }

  ///хадгалсан мэдээллийг шинэчлэх
  updateCachedPrograms(
      SharedPreferences prefs, String cacheKey, List<Program> programs) {
    try {
      _logger.info("shared local storage updating... ${programs.length}");
      String updatedValue = jsonEncode(programs);
      prefs.setString(cacheKey, updatedValue);
      _logger.warning(
          "Хугацаа нь дууссан програмуудыг санах ойгоос цэвэрлэлээ: $updatedValue");
    } catch (e) {
      _logger.warning("Program.toJson алдаа гарлаа : $e");
    }
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
