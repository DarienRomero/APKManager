import 'package:apk_manager/core/config_reader.dart';
import 'package:apk_manager/core/themes.dart';
import 'package:apk_manager/core/updates.dart';
import 'package:apk_manager/features/apps/providers/apps_provider.dart';
import 'package:apk_manager/features/auth/providers/user_provider.dart';
import 'package:apk_manager/features/common/controllers/notification_controller.dart';
import 'package:apk_manager/features/common/router_page.dart';
import 'package:apk_manager/features/company/providers/company_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  return Future<void>.value();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  final notificationController = NotificationController();
  AppLifecycleState currentState = AppLifecycleState.resumed;
  final navigatorKey = GlobalKey<NavigatorState>();
  bool requestingToken = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    notificationController.initNotifications(myBackgroundMessageHandler).then((value) {
      notificationController.getToken().then((value) {
        requestingToken = false;
        debugPrint("FCM TOKEN");
        debugPrint(value);
        //En el inicio de la aplicación solo se checkea actualizaciones de tienda
        //El OTA se actualiza cuando se carga la aplicación
        checkForUpdates();
      });
    });
    notificationController.mensajes.listen((event) {
      if(event.data["type"] == "ota_update"){
        final navigatorContext = getNavigatorContext();
        if(navigatorContext == null) return;
        setOtaUpdate(navigatorContext);
      }
      if(event.data["type"] == "store_update"){
        final navigatorContext = getNavigatorContext();
        if(navigatorContext == null) return;
        setStoreUpdate(navigatorContext);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //El !requestingToken sirve para que no se llame mientras se está solicitando el token
    if (state == AppLifecycleState.resumed && currentState == AppLifecycleState.inactive && !requestingToken) {
      //Se checkea actualizaciones de tienda y otas
      checkForUpdates();
    }
    currentState = state;
  }

  void checkForUpdates(){
    final navigatorContext = getNavigatorContext();
    if(navigatorContext == null) return;
    setStoreUpdate(navigatorContext).then((value) {
      setOtaUpdate(navigatorContext);
    });
  }

  BuildContext? getNavigatorContext(){
    return navigatorKey.currentState?.context;
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
        navigatorKey: navigatorKey,
        title: ConfigReader.getAppName(),
        theme: Themes.lightMode,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('es', '')
        ],
        locale: Locale('es', ''),
        home: RouterPage()
      ),
    );
  }
}