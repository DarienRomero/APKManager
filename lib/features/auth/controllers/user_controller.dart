import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {

  UserController._privateConstructor();
  static final UserController _instance = UserController._privateConstructor();
  factory UserController() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String usersCollection = "user";

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream(String userId) => 
    _db.collection(usersCollection).doc(userId).snapshots();
}