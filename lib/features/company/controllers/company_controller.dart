
import 'dart:io';

import 'package:apk_manager/features/common/models/error_response.dart';
import 'package:apk_manager/features/company/models/company_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyController {

  CompanyController._privateConstructor();
  static final CompanyController _instance = CompanyController._privateConstructor();
  factory CompanyController() => _instance;

  final String companyCollection = "company";
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<dynamic> fetchCompanyById(String id) async {
    try {
      DocumentSnapshot docsRef = await _db.collection(companyCollection).doc(id).get();
      final data = docsRef.data() as Map<String, dynamic>?;
      if (data != null) {
        return CompanyModel.fromJson(data);
      }
      return ErrorResponse.notFound;
    }  on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }

}
