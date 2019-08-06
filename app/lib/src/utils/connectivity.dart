import 'package:connectivity/connectivity.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:logging/logging.dart';

class NetworkConnectivity {
  final Logger log = new Logger('NetworkConnectivity');
  checkNetworkConnectivity() async {
    log.fine('checking network access...');
    Connectivity connectivity = Connectivity();

    //холболт шалгах
    var connectivityResult = await (connectivity.checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      log.fine('mobile data ашиглаж байна');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      log.fine('wifi ашиглаж байна');
    } else
      Constants.notificationCheckConnection();
  }
}
