import 'dart:async';

import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/home/socket_controller.dart';
import 'package:djizhub_light/utils/security/security_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../auth/signup.dart';
import '../../globals.dart';
class ReenterPin extends StatefulWidget {
  static final reverificationFormKey = GlobalKey<FormState>();
  String rightPin;
  ReenterPin({super.key,required this.rightPin});

  @override
  State<ReenterPin> createState() => _EnterPinState();
}

class _EnterPinState extends State<ReenterPin> {
  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  Widget build(BuildContext context) {
    SecurityController securityController = Get.find<SecurityController>();
    SocketController socketController = Get.find<SocketController>();
    final pinController = TextEditingController();
    const storage = FlutterSecureStorage();

    StreamController<ErrorAnimationType>? errorController;

    bool hasError = false;

    @override
    void initState() {
      errorController = StreamController<ErrorAnimationType>();
      super.initState();
    }

    @override
    void dispose() {
      errorController!.close();

      super.dispose();
    }



    return Scaffold(
      body:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
          child: Form(
            key: ReenterPin.reverificationFormKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: ()async{
                      try{
                        socketController.disconnectToWebsocket();
                        //   socket.disconnect();
                        //     socket.dispose();
                      }catch(e){
                        print(e);
                      }finally{
                        storage.deleteAll();
                        await GoogleSignIn().signOut();
                        FirebaseAuth auth = FirebaseAuth.instance;
                        auth.signOut().then((res) {
                          securityController.removeOverlay();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                                  (Route<dynamic> route) => false);
                        });
                      }

                    }, child: Text("Se déconnecter",textAlign: TextAlign.start,)),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        SizedBox(
                            width: MediaQuery.of(context).size.width*0.8,
                            child: Text("Vérification",textAlign: TextAlign.center,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),)),
                        SizedBox(height: 35,),
                        SizedBox(
                            width: MediaQuery.of(context).size.width*0.8,
                            child: Text("Entrez votre code secret",textAlign: TextAlign.center,)),
                        SizedBox(height: 35,),

                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Padding(
                            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.15,right:MediaQuery.of(context).size.width*0.15),
                            child: ShakeMe(
                              // 4. pass the GlobalKey as an argument
                              key: shakeKey,
                              // 5. configure the animation parameters
                              shakeCount: 3,
                              shakeOffset: 10,
                              shakeDuration: Duration(milliseconds: 500),
                              child: PinCodeTextField(
                                appContext: context,
                                autoDismissKeyboard: false,
                                autoFocus: true,
                                length: 4,
                                obscureText: true,
                                obscuringCharacter: '*',
                                blinkWhenObscuring: true,
                                animationType: AnimationType.scale,
                                validator: (v) {
                                  if (v!.length != 4) {
                                    return "";
                                  } else if(widget.rightPin != v) {
                                    return "code incorrect";
                                  }else{
                                    return null;
                                  }

                                },
                                pinTheme: PinTheme(

                                  disabledColor: Colors.grey,
                                  inactiveFillColor: Colors.white,
                                  inactiveColor: Colors.black87 ,
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
                                  if(this.widget.rightPin == v){


                                    securityController.startListening();
                                    securityController.removeOverlay();


                                  }else{
                                    shakeKey.currentState?.shake();

                                  }
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
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      /*
      Form(
        key: formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Text("Vérification",textAlign: TextAlign.center,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),)),
              SizedBox(height: 35,),
              SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Text("Entrez votre code pin pour acceder à l'application",textAlign: TextAlign.center,)),
              SizedBox(height: 35,),
              Directionality(
                // Specify direction if desired
                textDirection: TextDirection.ltr,
                child: Pinput(
                  autofocus: true,
                  // useNativeKeyboard: false,
                  obscuringCharacter: '*',
                  obscureText: true,
                  controller: pinController,
                  focusNode: focusNode,
                  androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsUserConsentApi,
                  listenForMultipleSmsOnAndroid: true,
                  defaultPinTheme: defaultPinTheme,
                  separatorBuilder: (index) => const SizedBox(width: 8),
                  validator: (value) {
                    return value == '2222' ? null : '';
                  },
                  // onClipboardFound: (value) {
                  //   debugPrint('onClipboardFound: $value');
                  //   pinController.setText(value);
                  // },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    debugPrint('onCompleted: $pin');
                  },
                  onChanged: (value) {
                    debugPrint('onChanged: $value');
                  },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: focusedBorderColor,
                      ),
                    ],
                  ),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

       */
    );
  }
}
