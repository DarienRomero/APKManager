import 'dart:async';

import 'package:apk_manager/core/navigation.dart';
import 'package:apk_manager/core/utils.dart';
import 'package:apk_manager/features/apps/providers/apps_provider.dart';
import 'package:apk_manager/features/apps/widgets/app_list_view.dart';
import 'package:apk_manager/features/auth/models/user_model.dart';
import 'package:apk_manager/features/auth/pages/sign_in_page.dart';
import 'package:apk_manager/features/auth/providers/user_provider.dart';
import 'package:apk_manager/features/common/controllers/notification_controller.dart';
import 'package:apk_manager/features/common/widgets/scaffold_wrapper.dart';
import 'package:apk_manager/features/common/widgets/v_spacing.dart';
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
  List<String> appsEnabled = [];
  int keyCounter = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;
      appsProvider.getApps(currentUser);
      userProvider.getUserSubscription();
      userSubs = userProvider.userStream.listen((event) {
        //TODO: Mejorar comparacion de listas
        if(appsEnabled.length != event.appsEnabled.length || currentUser.isAdmin != event.isAdmin ){
          appsProvider.getApps(event);
        }
        if(currentUser.enabled && !event.enabled){
          signOut();
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    userSubs?.cancel();
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
      body: SingleChildScrollView(
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
                        onPressed: signOut,
                        icon: const Icon(Icons.logout)
                      )
                    ],
                  );
                }
              ),
              const VSpacing(3),
              AppListView(
                key: Key("counter_$keyCounter"),
                appsProvider: appsProvider,
              )
            ],
          ),
        ),
      ),
    );
  }
  void signOut() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentAppsEnabled = userProvider.currentUser.appsEnabled;
    await userProvider.signOut();
    await notificationController.unsubscribeToTopics(currentAppsEnabled);
    if(!mounted) return;
    Navigator.pushAndRemoveUntil(context, materialNavigationRoute(context, const SignInPage()), (route) => false);
  }
}