import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderService{
  void textMe({required BuildContext context, required String text, required String number})
  async {
    // Android
    var uri = 'sms:$number?body=$text';
    if (await launch(uri)) {
      await launch(uri);
    } else {
      // iOS
      var uri = 'sms:$number?body=$text';
      if (await launch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  void launchUrl(number) async {
    await launch(number) ? await launch(number) : throw " Could'nt Launch $number";
  }
}