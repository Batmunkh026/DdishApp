import 'package:ddish/src/models/program.dart';
import 'package:ddish/src/models/result.dart';

class ProgramResponse {
  Result result;
  ProgramList programList;

  ProgramResponse.fromJson(Map<String, dynamic> json)
  : result = Result.fromJson(json),
  programList = ProgramList.fromJson(json['programList']);

}