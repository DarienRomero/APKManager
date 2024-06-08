import 'dart:async';

import 'package:apk_manager/features/company/controllers/company_controller.dart';
import 'package:apk_manager/features/company/models/company_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompanyProvider extends ChangeNotifier {
  StreamSubscription<dynamic>? companySubs;
  bool companySubsError = false;
  bool companySubsLoading = false;

  final _companyController = StreamController<CompanyModel>.broadcast();
  Function(CompanyModel) get companySink => _companyController.sink.add;
  Stream<CompanyModel> get companyStream => _companyController.stream;

  final companyController = CompanyController();

  CompanyModel currentCompany = CompanyModel.empty;

  Future<void> getCompanySubscription(String companyId) async {
    if(companySubs != null) return;
    companySubsError = false;
    companySubs = companyController.companyStream(companyId).listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      final data = snapshot.data();
      if(data == null){
        companySubsError = true;
        companySubsLoading = false;
        notifyListeners();
        return;
      }
      final newcompany = CompanyModel.fromJson(data);
      companySubsLoading = false;
      companySubsError = false;
      currentCompany = newcompany;
      companySink(newcompany);
      notifyListeners();
    }, onError: (error){
      companySubsLoading = false;
      companySubsError = true;
      notifyListeners();
    });
  }
}