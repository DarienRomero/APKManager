import 'dart:async';

import 'package:apk_manager/features/apps/controllers/apps_controller.dart';
import 'package:apk_manager/features/apps/models/app_model.dart';
import 'package:apk_manager/features/auth/models/user_model.dart';
import 'package:apk_manager/features/common/controllers/files_controller.dart';
import 'package:apk_manager/features/common/models/error_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppsProvider extends ChangeNotifier {

  final appsController = AppsController();
  final filesController = FilesController();

  //ALL

  bool appsLoading = false;
  bool appsError = false;
  List<AppModel> apps = [];

  StreamSubscription<dynamic>? appsSubs;

  Future<void> getApps(UserModel currentUser) async {
    if(apps.isEmpty){
      appsLoading = true;
    }
    appsError = false;
    notifyListeners();
    appsSubs = appsController.appsStream(currentUser.id, currentUser.appsEnabled, currentUser.isAdmin).listen((QuerySnapshot<Map<String, dynamic>> snapshots) {
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

  bool downloadFileLoading = false;
  bool downloadFileError = false;

  Future<dynamic> startDownloadFile(AppModel appModel) async {
    downloadFileLoading = true;
    downloadFileError = false;
    notifyListeners();
    final name = appModel.lastVersionLink.split("/").lastOrNull;
    final resp = await filesController.downloadFile(appModel.lastVersionLink, name ?? appModel.name.toLowerCase().replaceAll(" ", ""));
    if(resp is ErrorResponse){
      downloadFileLoading = false;
      downloadFileError = true;
      notifyListeners();
      return resp;
    }
    downloadFileLoading = false;
    downloadFileError = false;
    notifyListeners();
    return resp;
  }
}