import 'package:djizhub_light/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/home.dart';


class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
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
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
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
                        child: Text('Envoyer'),
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
                    )
                  ]))),
        ));
  }

  void logInToFb() {
    String newMail = emailController.text.replaceAll(' ', '');
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: newMail, password: passwordController.text)
        .then((result) {
          print("Access token : ");
          print(result.credential?.accessToken);
      isLoading = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
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