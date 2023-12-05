
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:djizhub_light/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../globals.dart';
class SettingPage extends StatelessWidget {
  IO.Socket socket;
   SettingPage({super.key,required this.socket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reglage"),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0,left: 30.0,right: 30.0,bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(FirebaseAuth.instance.currentUser?.email ?? "",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Général",style: TextStyle(fontSize: 16,color: Colors.black38),),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              //    backgroundBlendMode: BlendMode.overlay,
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white54,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 20,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(children: [
                                    Icon(Icons.share,size: 25,),
                                    SizedBox(width: 10,),
                                    Text("Inviter un ami à partager",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                  ],),
                                  SizedBox(height: 15,),
                                  Row(children: [
                                    Icon(Icons.brightness_5_outlined,size: 25,),
                                    SizedBox(width: 10,),
                                    Text("Faire chose ",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                  ],),
                                  SizedBox(height: 15,),
                                  Row(children: [
                                    Icon(Icons.add_a_photo_outlined,size: 25,),
                                    SizedBox(width: 10,),
                                    Text("En faire encore",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                  ],)
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Support",style: TextStyle(fontSize: 16,color: Colors.black38),),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              //    backgroundBlendMode: BlendMode.overlay,
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white54,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 20,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(children: [
                                    Icon(Icons.call,size: 25,),
                                    SizedBox(width: 10,),
                                    Text("Contacter le service client",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                  ],),
                                  SizedBox(height: 15,),
                                  Row(children: [
                                    Icon(Icons.web,size: 25,),
                                    SizedBox(width: 10,),
                                    Text("Visiter le site",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                  ],),
                                  SizedBox(height: 15,),
                                  Row(children: [
                                    Icon(Icons.group_add,size: 25,),
                                    SizedBox(width: 10,),
                                    Text("Collaboration",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                  ],)
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        InkWell(
                          onTap: () async {
                            socket.disconnect();
                            socket.dispose();
                            await GoogleSignIn().signOut();
                            FirebaseAuth auth = FirebaseAuth.instance;
                            auth.signOut().then((res) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUp()),
                                      (Route<dynamic> route) => false);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                //    backgroundBlendMode: BlendMode.overlay,
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white54,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 20,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Icon(Icons.logout_rounded,size: 25,),
                                      SizedBox(width: 10,),
                                      Text("Se déconnecter",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                    ],),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 30,),
              Column(
                children: [
                  Text("Djizhub",style: TextStyle(color: Colors.black26,fontSize: 11),),
                  Text("Version 1.0.0",style: TextStyle(color: Colors.black26,fontSize: 11),),
                  Text("Conditions Générales | Avis de Confidentialité",style: TextStyle(color: Colors.black26,fontSize: 11),),
                ],
              )
            ],

          ),
        ),
      ),

      /*
      Padding(
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
                        onPressed: () async {

                          await GoogleSignIn().signOut();
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

       */
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