import 'dart:io';

import 'package:apk_manager/features/auth/models/user_model.dart';
import 'package:apk_manager/features/common/models/error_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {

  AuthController._privateConstructor();
  static final AuthController _instance = AuthController._privateConstructor();
  factory AuthController() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final String usersCollection = "user";

  Future<dynamic> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      return ErrorResponse(
        statusCode: 400, 
        message: e.code
      );
    } on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }
  Future<dynamic> sendRecoverPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if(e.code == "invalid-email"){
        return ErrorResponse(
          statusCode: 400, 
          message: "El email ingresado es inválido"
        );
      }else if (e.code == "missing-android-pkg-name"){
        return ErrorResponse(
          statusCode: 401, 
          message: "Error desconocido"
        );
      }else if (e.code == "missing-continue-uri"){
        return ErrorResponse(
          statusCode: 402, 
          message: "Error desconocido"
        );
      }else if (e.code == "missing-ios-bundle-id"){
        return ErrorResponse(
          statusCode: 403, 
          message: "Error desconocido"
        );
      }else if (e.code == "invalid-continue-uri"){
        return ErrorResponse(
          statusCode: 404, 
          message: "Error desconocido"
        );
      }else if (e.code == "unauthorized-continue-uri"){
        return ErrorResponse(
          statusCode: 405, 
          message: "Error desconocido"
        );
      }else if (e.code == "user-not-found"){
        return ErrorResponse(
          statusCode: 406, 
          message: "El usuario no se encuentra registrado"
        );
      }else{
        return ErrorResponse.unknown;
      }
    } on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }
  Future<dynamic> signInUserEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      if(credential.user != null){
        return credential.user!;
      }else{
        return ErrorResponse.unknown;
      }
    } on FirebaseAuthException catch (e) {
      //TODO: Corregir mensajes de error
      if(e.code == "invalid-email"){
        return ErrorResponse(
          statusCode: 400, 
          message: "El email ingresado es inválido"
        );
      }else if (e.code == "user-disabled"){
        return ErrorResponse(
          statusCode: 401, 
          message: "El usuario se encuentra suspendido"
        );
      }else if (e.code == "user-not-found"){
        return ErrorResponse(
          statusCode: 402, 
          message: "El usuario no se encuentra registrado"
        );
      }else if (e.code == "wrong-password"){
        return ErrorResponse(
          statusCode: 403, 
          message: "La contraseña es incorrecta o no está registrado con email"
        );
      }else{
        return ErrorResponse.unknown;
      }
    } on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }

  Future<dynamic> loadUserSession() async {
    final user = _auth.currentUser;
    if(user == null){
      return ErrorResponse.notFound;
    }
    final data = await fetchUserById(user.uid);
    return data;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> currentUserStream(String userId) => _db.collection(usersCollection).doc(userId).snapshots();
  
  Future<dynamic> fetchUserById(String id) async {
    try {
      DocumentSnapshot docsRef = await _db.collection(usersCollection).doc(id).get();
      final data = docsRef.data() as Map<String, dynamic>?;
      if (data != null) {
        return UserModel.fromJson(data);
      }
      return ErrorResponse.notFound;
    }  on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }
  Future<dynamic> updateToken(String userId, String token) async {
    try {
      DocumentReference refUser = _db.collection(usersCollection).doc(userId);
      await refUser.update({
        "token": token
      });
      return true;
    }  on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }
}