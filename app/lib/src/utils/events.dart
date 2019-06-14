import 'package:url_launcher/url_launcher.dart';
class Events{
  Future<void> callEvent(final phoneNumber)async{
    //TODO утасны дугаарыг дамжуулах
      var url = 'tel:${phoneNumber}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
  }
}