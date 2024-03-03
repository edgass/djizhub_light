import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/main.dart';
import 'package:djizhub_light/utils/security/Reenter_pin.dart';
import 'package:djizhub_light/utils/security/enter_pin.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class SecurityController extends GetxController{

  String currentPin = "";
  late OverlayEntry overlayEntry;
  late SessionConfig sessionConfig;
  final sessionStateStream = StreamController<SessionState>();
  bool canAskPin = true;
  static final _auth = LocalAuthentication();
  AuthController authController = Get.find<AuthController>();

  startListening() {
    print("start listning");
    sessionStateStream.add(SessionState.startListening);
    update();
    print("start added");
  }

  stopListening(){
    print("stop listning");
    sessionStateStream.add(SessionState.stopListening);
    update();
  }

  stopListeningStream(){
    sessionConfig.dispose();
  }

  startTimer(){
    canAskPin = false;
    Future.delayed(const Duration(minutes: 2), () {
      canAskPin = true;
    });

  }

  listenStream(){
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {

        // handle user  inactive timeout
        // Navigator.of(context).pushNamed("/auth");
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        print("Focus perdu");
        stopListening();
        showOverlay(Get.overlayContext!);
        // handle user  app lost focus timeout
        // Navigator.of(context).pushNamed("/auth");
      }
    });
  }

  @override
  void onInit() {
     sessionConfig = SessionConfig(
        invalidateSessionForAppLostFocus: const Duration(seconds:60),
        invalidateSessionForUserInactivity: const Duration(seconds: 60));



      startListening();
      listenStream();
    // TODO: implement onInit
    super.onInit();
     overlayEntry =OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Material(
            color: Colors.transparent,
            child: ReenterPin(rightPin: currentPin,)
        ),
      ),
    );

  }






  setCurrentPin(String? pin){
    print("Current pin set $pin");
    currentPin = pin ?? "";
  }

  void removeOverlay(){
    print("removing");
    overlayEntry.remove();
  }


  void showOverlay(BuildContext context) {

    Overlay.of(context)?.insert(overlayEntry);

    // Vous pouvez ajuster la durée de persistance de la page au besoin

  }

  //Biometric Local_auth

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

   Future<bool> authenticateInEnterPin() async {
    print("Auth launched");
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      bool auth =  await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
        /*
        authMessages: [
          IOSAuthMessages(

          ),
          AndroidAuthMessages(
            cancelButton: 'Entrer le code',
          )
        ],
        */
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true
        ),
      );

      if(auth) {
        String? pin = await authController.searchPinInCache();
        setCurrentPin(pin);
        startListening();
        Get.offAll(()=>Home());
      }
      return auth;

    } on PlatformException catch (e) {
      print(e);
      return false;

    }
  }
  Future<bool> authenticateInRenterPin() async {
    print("Auth launched");
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      bool auth =  await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
        options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
            useErrorDialogs: true
        ),
      );

      if(auth) {
        startListening();
        removeOverlay();
      }
      return auth;

    } on PlatformException catch (e) {
      print(e);
      return false;

    }
  }








}