import 'dart:async';

import 'package:apk_manager/features/auth/controllers/auth_controller.dart';
import 'package:apk_manager/features/auth/controllers/user_controller.dart';
import 'package:apk_manager/features/auth/models/user_model.dart';
import 'package:apk_manager/features/common/models/error_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final authController = AuthController();
  final userController = UserController();

  UserModel currentUser = UserModel.empty;
  bool currentUserLoading = false;
  bool currentUserError = false;

  Future<dynamic> getCurrentUser() async {
    currentUserLoading = true;
    currentUserError = false;
    notifyListeners();
    final data = await authController.loadUserSession();
    if (data is ErrorResponse) {
      currentUserLoading = false;
      currentUserError = true;
      notifyListeners();
      return data;
    }
    currentUser = data as UserModel;
    currentUserLoading = false;
    currentUserError = false;
    notifyListeners();
    return currentUser;
  }

  void setNewUser(UserModel newUser) {
    currentUser = newUser;
    notifyListeners();
  }

  void clearNewUser(){
    currentUser = UserModel.empty;
  }

  StreamSubscription<dynamic>? userSubs;
  bool userSubsError = false;
  bool userSubsLoading = false;

  final _userController = StreamController<UserModel>.broadcast();
  Function(UserModel) get userSink => _userController.sink.add;
  Stream<UserModel> get userStream => _userController.stream;

  Future<void> getUserSubscription() async {
    if(userSubs != null) return;
    userSubsError = false;
    userSubs = userController.userStream(currentUser.id).listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      final data = snapshot.data();
      if(data == null){
        userSubsError = true;
        userSubsLoading = false;
        notifyListeners();
        return;
      }
      final newUser = UserModel.fromJson(data);
      userSubsLoading = false;
      userSubsError = false;
      currentUser = newUser;
      userSink(newUser);
      notifyListeners();
    }, onError: (error){
      userSubsLoading = false;
      userSubsError = true;
      notifyListeners();
    });
  }

  bool loadingSignOut = false;

  Future<void> signOut() async {
    loadingSignOut = true;
    notifyListeners();
    await authController.signOut();
    loadingSignOut = false;
    notifyListeners();
    currentUser = UserModel.empty;
  }

  @override
  void dispose() {
    userSubs?.cancel();
    super.dispose();
  }
}
