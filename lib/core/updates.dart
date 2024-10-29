import 'dart:io';
import 'dart:isolate';

import 'package:apk_manager/core/config_reader.dart';
import 'package:apk_manager/core/launcher_utils.dart';
import 'package:apk_manager/features/common/controllers/common_controller.dart';
import 'package:apk_manager/features/common/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

void setOtaUpdate(BuildContext context) async {
  final shorebirdCodePush = ShorebirdCodePush();
  final isUpdateAvailable = await Isolate.run<bool>(() async {
    final isUpdateAvailable = await shorebirdCodePush.isNewPatchAvailableForDownload();
    return isUpdateAvailable;
  });
  if(isUpdateAvailable){
    if(!context.mounted) return;
    await showOtaUpdateAlert(context);
    await shorebirdCodePush.downloadUpdateIfAvailable();
  }
}

Future<void> showOtaUpdateAlert(context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Información"),
      content: Text("Hay una nueva versión de ${ConfigReader.getAppName()}."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Continuar")
        ),
      ],
    )
  );
}

Future<void> setStoreUpdate(BuildContext context) async {
  final commonController = CommonController();
  final appUpdate = await commonController.checkForUpdates();
  if(appUpdate == null) return;
  final isAndroid = Platform.isAndroid;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String buildNumber = packageInfo.buildNumber;
  bool forced = appUpdate.forced;
  if (appUpdate.versionNumber > int.parse(buildNumber)) {
    if(!context.mounted) return;
    showDialog(
      barrierDismissible: !forced,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          appUpdate.title,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textTheme.displayLarge!.color
          )
        ),
        content: Text(appUpdate.description),
        actions: [
          !forced
            ? TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Ahora no",
                  style: TextStyle(color: Colors.grey)
                )
              )
            : Container(),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: Text("Actualizar", style: TextStyle(color: Theme.of(context).primaryColor))
          ),
        ]
      )
    ).then((value) async {
      if (value == null) {
        if (forced) {
          SystemNavigator.pop();
        }
      } else {
        String url = '';
        if(!isAndroid){
          url = "https://apps.apple.com/pe/app/miruta-viajes/id1669513361";
        }else{
          url = 'https://play.google.com/store/apps/details?id=com.hadtech.mirutaapp';
        }
        bool success = await LauncherUtils.openUrl(context, url);
        if (!success) {
          if(!context.mounted) return;
          showInfoAlert(
            context,
            "Atención",
            "Debe ir a ${isAndroid ? "PlayStore" : "AppStore"} manualmente"
          );
        }
        if (forced) {
          SystemNavigator.pop();
        }
      }
    });
  }
}