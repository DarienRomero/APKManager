import 'package:apk_manager/core/themes.dart';
import 'package:apk_manager/features/apps/providers/apps_provider.dart';
import 'package:apk_manager/features/auth/providers/user_provider.dart';
import 'package:apk_manager/features/common/controllers/local_controller.dart';
import 'package:apk_manager/features/common/controllers/notification_controller.dart';
import 'package:apk_manager/features/common/router_page.dart';
import 'package:apk_manager/features/company/providers/company_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final localController = LocalController();
  await localController.initPrefs();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://2ecb5ea822029678fae6f9aa87120cb8@o1110619.ingest.us.sentry.io/4507425646313472';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
}

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