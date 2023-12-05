import 'package:djizhub_light/utils/security/Reenter_pin.dart';
import 'package:djizhub_light/utils/security/enter_pin.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class SecurityController extends GetxController{

  String currentPin = "";
  late OverlayEntry overlayEntry;

  @override
  void onInit() {
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