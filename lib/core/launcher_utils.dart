import 'dart:io';

import 'package:apk_manager/features/common/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static Future<bool> openUrl(BuildContext context, String urlString, {bool errorVisible = true}) async {
    try{
      if(Platform.isAndroid){
        // ignore: deprecated_member_use
        if (await canLaunch(urlString)) {
          // ignore: deprecated_member_use
          await launch(urlString);
          return true;
        } else {
          if(context.mounted) showErrorAlert(context: context, title: "Estimado usuario", message: ["No se pudo enviar el mensaje"]);
          return false;
        }
      }else{
        if (await canLaunchUrl(Uri.parse(urlString))) {
          await launchUrl(Uri.parse(urlString));
          return true;
        } else {
          if(context.mounted) showErrorAlert(context: context, title: "Estimado usuario", message: ["Lo sentimos, no se pudo enviar el mensaje"]);
          return false;
        }
      }
    }catch(_){
      if(errorVisible){
        showErrorAlert(context: context, title: "Estimado usuario", message: ["Lo sentimos, no se pudo enviar el mensaje"]);
      }
      return false;
    }
  }
}