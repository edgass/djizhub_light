import 'dart:math';

import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';

import '../globals.dart';
class Otp extends StatelessWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    AuthController authController = Get.find<AuthController>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/logo/logo.png",height: 130,),
              SizedBox(height: 10,),
              Text("Vérification",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
              Text("Un code a été envoyé au 77 247 77 30",textAlign: TextAlign.center),
              SizedBox(height: 25,),
              SizedBox(height: 10,),
              Pinput(
                length: 6,
               // defaultPinTheme: defaultPinTheme,
               // focusedPinTheme: focusedPinTheme,
               // submittedPinTheme: submittedPinTheme,
                validator: (s) {
                  return s == '111111' || s == '222222' ? null : 'Code Incorrect';
                },
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                pinAnimationType: PinAnimationType.scale,
                showCursor: true,
                onCompleted: (pin) async{
                  try{
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: authController.verify, smsCode: pin);
                    // Sign the user in (or link) with the credential
                    await auth.signInWithCredential(credential);
                    print("Success : User is Signed");
                  }catch(e){
                    print("Erreur lors de la verification du code");
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: 50,
                  child: ElevatedButton(// foreground
                    onPressed: () { },
                    child: Text('Renvoyer le code',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => apCol),
                      ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Text('Annuler',style: TextStyle(color: apCol),)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
