import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';


import 'auth/signup.dart';
import 'home/home.dart';


class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? result = FirebaseAuth.instance.currentUser;
    return SplashScreen(
        useLoader: true,
        loadingTextPadding: const EdgeInsets.all(0),
        loadingText: const Text(""),
        navigateAfterSeconds: result != null ? Home() : SignUp(),
        seconds: 3,
        title: const Text(
          'Bienvenue dans Djizub!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset('assets/logo/logo_random.png', fit: BoxFit.scaleDown),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: const TextStyle(),
        photoSize: 100.0,
        onClick: () => print("flutter"),
        loaderColor: Colors.red);
  }
}