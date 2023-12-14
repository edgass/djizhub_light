import 'dart:async';

import 'package:djizhub_light/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../auth/controller/auth_controller.dart';
import '../../globals.dart';
  class ConfirmCreatePin extends StatelessWidget {
   ConfirmCreatePin({super.key});
  static final confirmPinformKey = GlobalKey<FormState>();
  AuthController authController = Get.find<AuthController>();
   StreamController<ErrorAnimationType>? errorController;

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    final focusNode = FocusNode();

    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);



    return Scaffold(
      appBar: AppBar(
        actions: [Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Text("Se déconnecter",style: TextStyle(color: Colors.redAccent),),
        )],
      ),
      body:

      Form(
        key: confirmPinformKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Text("Retaper Code",textAlign: TextAlign.center,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),)),
              SizedBox(height: 35,),
              SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Text("Retapez votre code secret",textAlign: TextAlign.center,)),
              SizedBox(height: 35,),
              Directionality(
                // Specify direction if desired
                textDirection: TextDirection.ltr,
                child:Padding(
                  padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.15,right:MediaQuery.of(context).size.width*0.15),
                  child: PinCodeTextField(
                    appContext: context,

                    length: 4,
                    obscureText: true,
                    autoDismissKeyboard: false,
                    autoFocus: true,
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.scale,
                    validator: (v) {
                      if (v!.length != 4) {
                        return "";
                      }else if(v != authController.creatingPin){
                        return "Les pins ne correspondent pas";
                      } else{
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      disabledColor: Colors.grey,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Colors.black87,
                      activeColor: lightGrey,
                      selectedColor: lightGrey,
                      shape: PinCodeFieldShape.underline,

                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,

                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),


                    errorAnimationController: errorController,
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {
                      debugPrint("Completed");
                      print("v= $v");

                      print("pin ${authController.creatingPin}");
                      authController.setConfirmCreatingPin(v);
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
              ),
              TextButton(
                onPressed: () async{
                  focusNode.unfocus();
                  if(confirmPinformKey.currentState!.validate()){

                    print("c=${authController.creatingPin} cf=${authController.confirmingPin}");
                    if(authController.creatingPin == authController.confirmingPin){
                      print("sending to firebase");
                      await authController.addPinToFirebase();
                      print("End sending to firebase");
                    }
                    securityController.startListening();
                  }


                },
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),


    );
  }
}
