import 'dart:async';

import 'package:apk_manager/features/apps/controllers/apps_controller.dart';
import 'package:apk_manager/features/apps/models/app_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppsProvider extends ChangeNotifier {

  final appsController = AppsController();

  //ALL

  bool appsLoading = false;
  bool appsError = false;
  List<AppModel> apps = [];

  StreamSubscription<dynamic>? appsSubs;

  Future<void> getApps(String userId, List<String> appsEnabled) async {
    if(apps.isEmpty){
      appsLoading = true;
    }
    appsError = false;
    notifyListeners();
    appsSubs = appsController.appsStream(userId, appsEnabled).listen((QuerySnapshot<Map<String, dynamic>> snapshots) {
      final appsModel = appsController.parseApps(snapshots.docs);
      appsLoading = false;
      appsError = false;
      apps = appsModel;
      notifyListeners();
    }, onError: (error){
      appsLoading = false;
      appsError = true;
      apps = [];
      notifyListeners();
    });
  }
}