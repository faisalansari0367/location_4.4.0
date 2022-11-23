import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IntentService {
  static void noAppAvailable({String? msg}) {
    Fluttertoast.showToast(msg: msg ?? 'No app available to open this link');
  }

  static Future<bool> emailIntent(String? email, {String? subject, String? body}) async {
    var q = '';
    if (subject != null) q += 'subject=$subject';
    if (body != null) q += '&body=$body';

    final emailLaunchUri = Uri(scheme: 'mailto', path: email, query: q);
    final _email = emailLaunchUri.toString();
    final result = await canLaunchUrlString(_email);
    try {
      await launchUrl(Uri.parse(_email));
    } catch (e) {
      noAppAvailable();
    }
    return result;
  }

  static Future<bool> dialIntent(String phoneNumber) async {
    final phone = Uri(scheme: 'tel', path: phoneNumber).toString();
    final result = await canLaunchUrlString(phone);
    // if (result) await launchUrl(phone);
    // if (!result) noAppAvailable();
    try {
      await launchUrl(Uri.parse(phone));
    } catch (e) {
      log(e.toString());
      noAppAvailable();
    }
    return result;
  }
}
