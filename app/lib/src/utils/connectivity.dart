import 'package:connectivity/connectivity.dart';
import 'package:ddish/src/utils/constants.dart';

class NetworkConnectivity {
  checkNetworkConnectivity() async {
    print('checking network access...');
    Connectivity connectivity = Connectivity();

    //холболт шалгах
    var connectivityResult = await (connectivity.checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('mobile data ашиглаж байна');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('wifi ашиглаж байна');
    } else
      Constants.notificationCheckConnection();
  }
}
