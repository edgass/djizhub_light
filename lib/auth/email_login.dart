import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/home/home_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../home/home.dart';


class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthController authController = Get.find<AuthController>();


  bool isLoading = false;
  bool isLoadingSendForgetPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Se connecter")),
        body: Center(
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Adresse Mail",
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Entrez votre adresse mail';
                          } else if (!value.contains('@')) {
                            return 'Entrez une adresse mail valide !';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Entrez votre mot de passe';
                          } else if (value.length < 6) {
                            return 'Le mot de passe doit avoir plus de 6 caractéres!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(apCol)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            logInToFb();
                          }
                        },
                        child: Text('Envoyer',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: isLoadingSendForgetPassword
                          ? CircularProgressIndicator()
                          : TextButton(
                        onPressed: () {
                          if (emailController.text != null && emailController.text != "") {
                            setState(() {
                              isLoadingSendForgetPassword = true;
                            });
                            resetPassword(email: passwordController.text);
                          }
                        },
                        child: Text('Mot de passe oublié ?'),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SignInButton(

                          Buttons.Google,
                          text: "Connexion via Google",
                          onPressed: () {
                            authController.signInWithGoogle(context);
                          },
                        )),

                  ]))),
        ));
  }

  void logInToFb() {
    String newMail = emailController.text.replaceAll(' ', '');
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: newMail, password: passwordController.text)
        .then((result) {
          print(result.credential?.accessToken);
      isLoading = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeCheck()),
      );
    }).catchError((err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    setState(() {
      isLoading = false;
    });
  }

  void resetPassword({required String email}) async {
    print(emailController.text);
        FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text)
        .then((value) => print("Email envoyé avec succés"))
        .catchError((e) => print("erreur d'envoi de l'email de reinitialisation $e",));

        setState(() {
          isLoadingSendForgetPassword = false;
        });

  }
}