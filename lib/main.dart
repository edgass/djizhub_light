import 'package:djizhub_light/App_home.dart';
import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/auth/signup.dart';
import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/home/home_check.dart';
import 'package:djizhub_light/utils/binding.dart';
import 'package:djizhub_light/utils/loading.dart';
import 'package:djizhub_light/utils/local_notifications.dart';
import 'package:djizhub_light/utils/security/enter_pin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:socket_io_client/socket_io_client.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().initNotification();
  HomeBinding().dependencies();







  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  AuthController authController = Get.find<AuthController>();
   final storage = const FlutterSecureStorage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //scaffoldBackgroundColor: Color(0xFFF8F8F8),
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
        primaryColor: Color(0xFF70bccc),
        appBarTheme: AppBarTheme(
         // backgroundColor: lightGrey,

        )

      ),
    //  home: IntroScreen()
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future:  authController.searchPinInCache(),
              builder: (context, pinSnapshot) {
                if (pinSnapshot.connectionState == ConnectionState.waiting) {
                  // You can return a loading indicator or something here if needed.
                  return Loading();
                } else {
                  print("pin in cache = ${pinSnapshot.data}");

                  if (pinSnapshot.data != null) {

                    return EnterPin(rightPin: pinSnapshot.data ?? "",);
                  } else {
                    return HomeCheck();
                  }
                }
              },
            );
          } else {
            return SignUp();
          }
        },
      )
    );
  }
}
