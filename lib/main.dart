import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/auth/signup.dart';
import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/home/home_check.dart';
import 'package:djizhub_light/utils/binding.dart';
import 'package:djizhub_light/utils/dynamic_links.dart';
import 'package:djizhub_light/utils/loading.dart';
import 'package:djizhub_light/utils/local_notifications.dart';
import 'package:djizhub_light/utils/security/enter_pin.dart';
import 'package:djizhub_light/utils/security/security_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


final navigatorKey = GlobalKey<NavigatorState>();
void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  NotificationService().initFCMNotifications();
  NotificationService().initNotification();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HomeBinding().dependencies();
  DynamicLinksProvider().initDynamicLink();
  /*
  if(!kIsWeb){
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kDebugMode ? false : true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  */

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp( MyApp());
}




class MyApp extends StatelessWidget {
   MyApp({super.key});
  AuthController authController = Get.find<AuthController>();
  SecurityController securityController = Get.find<SecurityController>();
   final storage = const FlutterSecureStorage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
        localizationsDelegates: const[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('fr')
        ],
    debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'poppins',
       // scaffoldBackgroundColor: Color(0xFFF2F2F0),
        colorScheme: ColorScheme.fromSeed(
            seedColor:  lightGrey,
            brightness: Brightness.light,
            primary:  lightGrey,
            secondary: lightGrey),
      //  useMaterial3: true,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: Colors.blue,
        primaryColor: const Color(0xff00597e),
        appBarTheme: const AppBarTheme(
         // backgroundColor: lightGrey,

        )

      ),
    //  home: IntroScreen()
      home: SessionTimeoutManager(
        userActivityDebounceDuration: const Duration(seconds: 1),
        sessionConfig: securityController.sessionConfig,
        sessionStateStream: securityController.sessionStateStream.stream,
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),

          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                future:  authController.searchPinInCache(),
                builder: (context, pinSnapshot) {
                  if (pinSnapshot.connectionState == ConnectionState.waiting) {
                    // You can return a loading indicator or something here if needed.
                    securityController.stopListening();

                    return const Loading();
                  } else {
                    print("pin in cache = ${pinSnapshot.data}");

                    if (pinSnapshot.data != null) {
                      securityController.stopListening();

                      return EnterPin(rightPin: pinSnapshot.data ?? "",);
                    } else {
                      securityController.stopListening();

                      return const HomeCheck();
                    }
                  }
                },
              );
            } else {
              securityController.stopListening();
              return SignUp();
            }
          },
        ),
      )
    );
  }
}


