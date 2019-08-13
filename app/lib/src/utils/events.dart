import 'dart:io';

import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

class Events {
  var logger = Logger("Events");
  callEvent(final phoneNumber) {
    var url = 'tel:${phoneNumber}';
    logger.info('$url дугаар руу залгаж байна...');
    _launchURL(url);
  }

  void smsEvent(String phoneNumber, content) {
    final separator = Platform.isIOS ? '&' : '?';

    logger.info('$phoneNumber дугаар руу `$content` sms илгээх гэж байна...');
    _launchURL(
        'sms:$phoneNumber${separator}body=${Uri.encodeFull('$content')}&subject=${Uri.encodeFull('')}');
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      logger.warning('Could not launch $url');
    }
  }
}
