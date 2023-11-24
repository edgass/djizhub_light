
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:djizhub_light/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../globals.dart';
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap:()=>Navigator.pop(context),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: apCol,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: const Icon(Icons.clear,),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)),
                        onPressed: () {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          auth.signOut().then((res) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => SignUp()),
                                    (Route<dynamic> route) => false);
                          });
                        },
                        child: const Text("Deconnexion")),
                    ElevatedButton(

                        onPressed: () {
                            copyToken(context);
                        },
                        child: const Text("Copier le token")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void copyToken(BuildContext ctx) async {
  // Fetch the currentUser, and then get its id token
  if(FirebaseAuth.instance.currentUser != null){
    final user = await FirebaseAuth.instance.currentUser!;
  final idToken = await user.getIdToken();
  print(idToken);

    Clipboard.setData(ClipboardData(text: idToken ?? "Erreur" )).then((_){
      ScaffoldMessenger.of(ctx)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(      elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Succés!',
            message:
            'Token copié avec succés',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),));
    });

  }







/*

_httpsCall() async {
  // Fetch the currentUser, and then get its id token
  final user = await FirebaseAuth.instance.currentUser();
  final idToken = await user.getIdToken();
  final token = idToken.token;

  // Create authorization header
  final header = { "authorization": 'Bearer $token' };

  get("http://YOUR_PROJECT_BASE_URL/httpsFunction", headers: header)
      .then((response) {
    final status = response.statusCode;
    print('STATUS CODE: $status');
  })
      .catchError((e) {
    print(e);
  });

  */

}