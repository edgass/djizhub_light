import 'package:djizhub_light/main.dart';
import 'package:djizhub_light/utils/security/Reenter_pin.dart';
import 'package:djizhub_light/utils/security/enter_pin.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

class SecurityController extends GetxController{

  String currentPin = "";
  late OverlayEntry overlayEntry;
  late SessionConfig sessionConfig;
  final sessionStateStream = StreamController<SessionState>();
  bool canAskPin = true;

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



}