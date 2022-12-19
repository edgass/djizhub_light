import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import 'otp.dart';


class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/logo/logo.png",height: 130,),
        const SizedBox(height: 10,),
        SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: TextField(

            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              filled: true,
              prefixIcon: const Icon(Icons.phone_in_talk),
              prefixText: '+221',
              hintText: 'Numéro de téléphone',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value){
              authController.setNumberToVerify(value);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width*0.7,
            height: 50,
            child: ElevatedButton(// foreground
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => apCol)
              ),
              onPressed: () {
                authController.verifyNumber("+221${authController.numberToVerify}");
              },
              child: const Text('Se connecter',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
          ),
        ),
      ],
    );
  }
}
