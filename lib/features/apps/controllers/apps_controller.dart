import 'package:apk_manager/features/apps/models/app_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppsController {

  AppsController._privateConstructor();
  static final AppsController _instance = AppsController._privateConstructor();
  factory AppsController() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String appsCollection = "app";

  Stream<QuerySnapshot<Map<String, dynamic>>> appsStream(String userId, List<String> appsEnabled, bool isAdmin) => isAdmin
    ? _db.collection(appsCollection).snapshots() :
  _db.collection(appsCollection).where("id", whereIn: appsEnabled).snapshots();

  //PARSE
  List<AppModel> parseApps(List<QueryDocumentSnapshot<Object?>> docs){
    List<AppModel> appsModels = [];
    for (QueryDocumentSnapshot snapshot in docs) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        appsModels.add(AppModel.fromJson(data));
      }
    }
    return appsModels;
  }
}