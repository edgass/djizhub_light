import 'dart:async';

import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/utils/security/confirm_create_pin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
  class CreatePin extends StatefulWidget {
   const CreatePin({super.key});
  static  final createPinformKey = GlobalKey<FormState>();

  @override
  State<CreatePin> createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {
  AuthController authController = Get.find<AuthController>();

   StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    final focusNode = FocusNode();



    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
        actions: const [Padding(
        padding: EdgeInsets.only(right: 15.0),
    child: Text("Se déconnecter",style: TextStyle(color: Colors.redAccent),),
    )],),
      body:   Form(
        key: CreatePin.createPinformKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: const Text("Code secret",textAlign: TextAlign.center,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),)),
              const SizedBox(height: 35,),
              SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: const Text("Creez un code secret pour restreindre l'accés à vos épargnes",textAlign: TextAlign.center,)),
              const SizedBox(height: 35,),

              Directionality(
                textDirection: TextDirection.ltr,
                child: Padding(
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
                      } else {
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
                      authController.setCreatingPin(v);
                      print("pin ${authController.creatingPin}");
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
                onPressed: () {
                  focusNode.unfocus();
                  if(CreatePin.createPinformKey.currentState!.validate()){
                    Get.to(transition: Transition.rightToLeftWithFade,

                            ()=>ConfirmCreatePin());
                  }

                },
                child: const Text('Suivant'),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
