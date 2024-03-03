import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/utils/termsConditions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';


class SignUp extends StatelessWidget {

  AuthController authController = Get.find<AuthController>();
  final String title = "Creer un Compte";

  SignUp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Center(
            child: Column(
                children: <Widget>[
              Image.asset('assets/logo/logo_djizhub_line.png',width: MediaQuery.of(context).size.width*0.45,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SignInButton(
                      Buttons.Email,
                      text: "Creer compte avec mail",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmailSignUp()),
                        );
                      },
                    )),

                 */
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30.0,left: 20.0,right: 20.0),
                      child: Text('Bonjour et bienvenues sur DJizhub ! Pour commencer, veuillez vous connecter.',textAlign: TextAlign.center,),
                    ),
                    SignInButton(

                      Buttons.Google,
                      text: "Connexion via Google",
                      onPressed: () {
                        authController.signInWithGoogle(context);
                      },
                    ),
                    /*
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                        child: const Text("Se connecter ",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EmailLogIn()),
                          );
                        }))
                */
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 20,bottom: 25),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 9.0,
                    ),
                    children: [
                      const TextSpan(
                        text: 'En se connectant à l\'application, j\'accepte les ',
                      ),
                      TextSpan(
                        text: 'termes et conditions',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Mettez ici le code à exécuter lorsque le lien est cliqué
                            Get.to(()=>TermsAndConditions());
                          },
                      ),
                      const TextSpan(
                        text: ' d\'utilisation de djizhub',
                      ),
                    ],
                  ),
              ),
            )]),
          ),
        ));
  }
}