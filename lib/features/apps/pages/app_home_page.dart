import 'dart:async';

import 'package:apk_manager/core/navigation.dart';
import 'package:apk_manager/core/utils.dart';
import 'package:apk_manager/features/apps/providers/apps_provider.dart';
import 'package:apk_manager/features/apps/widgets/app_list_view.dart';
import 'package:apk_manager/features/auth/models/user_model.dart';
import 'package:apk_manager/features/auth/pages/sign_in_page.dart';
import 'package:apk_manager/features/auth/providers/user_provider.dart';
import 'package:apk_manager/features/common/controllers/notification_controller.dart';
import 'package:apk_manager/features/common/widgets/alerts.dart';
import 'package:apk_manager/features/common/widgets/page_loader.dart';
import 'package:apk_manager/features/common/widgets/scaffold_wrapper.dart';
import 'package:apk_manager/features/common/widgets/v_spacing.dart';
import 'package:apk_manager/features/company/providers/company_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> with WidgetsBindingObserver {
  final notificationController = NotificationController();
  late AppsProvider appsProvider;
  StreamSubscription? userSubs;
  StreamSubscription? companySubs;
  List<String> appsEnabled = [];
  int keyCounter = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;
      final currentCompany = userProvider.currentUser;
      appsProvider.getApps(currentUser);
      userProvider.getUserSubscription();
      companyProvider.getCompanySubscription(currentUser.company);
      userSubs = userProvider.userStream.listen((event) {
        if(!compareStringLists(appsEnabled, event.appsEnabled) || currentUser.isAdmin != event.isAdmin ){
          appsProvider.getApps(event);
        }
        if(currentUser.enabled && !event.enabled){
          signOut("Su cuenta ha sido deshabilitada.");
        }
      });
      companySubs = companyProvider.companyStream.listen((event) {
        if(currentCompany.enabled && !event.enabled){
          signOut("La cuenta de la empresa asociada ha sido deshabilitada.");
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    userSubs?.cancel();
    companySubs?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      keyCounter++;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    appsProvider = Provider.of<AppsProvider>(context);
    return ScaffoldWrapper(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: mqWidth(context, 2.5)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VSpacing(8),
                  Selector<UserProvider, UserModel>(
                    selector: (context, userProvider) => userProvider.currentUser,
                    builder: (context, currentUser, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentUser.username, style: TextStyle(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              )),
                              Text(currentUser.email, style: TextStyle(
                                color: Colors.blue[300],
                                fontSize: 18,
                              )),
                            ],
                          ),
                          IconButton(
                            onPressed: ()=>signOut("", manually: true),
                            icon: const Icon(Icons.logout)
                          )
                        ],
                      );
                    }
                  ),
                  AppListView(
                    key: Key("counter_$keyCounter"),
                    appsProvider: appsProvider,
                  )
                ],
              ),
            ),
          ),
          Selector<AppsProvider, bool>(
            selector: (context, appsProvider) => appsProvider.downloadFileLoading,
            builder: (context, downloadFileLoading, _) {
              return PageLoader(
                loading: downloadFileLoading, 
                message: "Descargando apk...\nEsto puede tomar unos minutos"
              );
            }
          ),
          Selector<UserProvider, bool>(
            selector: (context, appsProvider) => appsProvider.loadingSignOut,
            builder: (context, loadingSignOut, _) {
              return PageLoader(
                loading: loadingSignOut, 
                message: "Cerrando sesión"
              );
            }
          )
          
        ],
      ),
    );
  }
  void signOut(String message, {bool manually = false}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentAppsEnabled = userProvider.currentUser.appsEnabled;
    await userProvider.signOut();
    await notificationController.unsubscribeToTopics(currentAppsEnabled);
    if(!mounted) return;
    if(!manually){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showInfoAlert(context, "Estimado usuario", message);
      });
    }
    Navigator.pushAndRemoveUntil(context, materialNavigationRoute(context, const SignInPage()), (route) => false);
  }
}