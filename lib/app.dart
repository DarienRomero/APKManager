import 'package:apk_manager/core/themes.dart';
import 'package:apk_manager/features/apps/providers/apps_provider.dart';
import 'package:apk_manager/features/auth/providers/user_provider.dart';
import 'package:apk_manager/features/common/controllers/notification_controller.dart';
import 'package:apk_manager/features/common/router_page.dart';
import 'package:apk_manager/features/company/providers/company_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final notificationController = NotificationController();

  @override
  void initState() {
    super.initState();
    notificationController.initNotifications().then((value) {
      notificationController.getToken().then((value) => print(value));
    });
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<AppsProvider>(
          create: (context) => AppsProvider(),
        ),
        ChangeNotifierProvider<CompanyProvider>(
          create: (context) => CompanyProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'APKManager',
        theme: Themes.lightMode,
        debugShowCheckedModeBanner: false,
        home: const RouterPage()
      ),
    );
  }
}