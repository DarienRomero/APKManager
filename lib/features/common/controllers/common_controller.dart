
import 'dart:io';

import 'package:apk_manager/features/common/models/app_update_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CommonController {
  CommonController._privateConstructor();
  static final CommonController _instance = CommonController._privateConstructor();
  factory CommonController() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String configurationCollection = "configuration";

  Future<AppUpdateModel?> checkForUpdates() async {
    try {
      late DocumentSnapshot snapshot;
      if (Platform.isAndroid) {
        snapshot = await _db.collection(configurationCollection).doc("android").get();
      } else {
        snapshot = await _db.collection(configurationCollection).doc("ios").get();
      }
      if(snapshot.data() != null){
        final data = snapshot.data() as Map<String, dynamic>;
        return AppUpdateModel.fromJson(data);
      }else{
        await Sentry.captureMessage(
          "checkForUpdates: EXCEPTION: none  BODY: none",
        );
        return null;
      }
    } catch (e) {
      await Sentry.captureMessage(
        "checkForUpdates: EXCEPTION: $e BODY: none",
      );
      return null;
    }
  }
}

