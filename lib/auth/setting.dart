
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:djizhub_light/auth/signup.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/home/socket_controller.dart';
import 'package:djizhub_light/utils/security/security_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_plus/share_plus.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';
class SettingPage extends StatelessWidget {

   SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    SecurityController securityController = Get.find<SecurityController>();
    SocketController socketController = Get.find<SocketController>();
    final storage = const FlutterSecureStorage();
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
                                  color: Colors.grey.shade200,
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
                                  InkWell(
                                    onTap: ()async=> _onShare(context),
                                    child: Row(children: [
                                      Icon(Icons.share,size: 25,),
                                      SizedBox(width: 10,),
                                      Text("Inviter un ami à partager",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                    ],),
                                  ),
                                  SizedBox(height: 15,),
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
                                  InkWell(
                                    onTap: ()async=>contactClientService(),
                                    child: Row(children: [
                                      Icon(Icons.call,size: 25,),
                                      SizedBox(width: 10,),
                                      Text("Contacter le service client",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                    ],),
                                  ),
                                  SizedBox(height: 15,),
                                  InkWell(
                                    onTap: ()async=>visitWebsite(),
                                    child: Row(children: [
                                      Icon(Icons.web,size: 25,),
                                      SizedBox(width: 10,),
                                      Text("Visiter le site",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                    ],),
                                  ),
                                  SizedBox(height: 15,),
                                  InkWell(
                                    onTap: ()async =>contactCollabo(),
                                    child: Row(children: [
                                      Icon(Icons.group_add,size: 25,),
                                      SizedBox(width: 10,),
                                      Text("Collaboration",style: TextStyle(fontSize: 16,color: Colors.black87),)
                                    ],),
                                  )
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

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUp()),
                                        (Route<dynamic> route) => false);
                              });
                            }


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

void _onShare(BuildContext context) async {
  ShareResult shareResult;
  securityController.stopListening();

  final box = context.findRenderObject() as RenderBox?;

    shareResult = await Share.shareWithResult("On modernise la tradition avec Djizhub, la Condané Digitale! 🚀 Téléchargez l'appli maintenant et faites revivre l'épargne d'une manière nouvelle et amusante. Télecharger l'app : https://play.google.com/store/apps/details?id=com.wave.personal&pcampaignid=web_share",
        subject: "💼 Retour aux sources avec Djizhub - La Condané Digitale! 💰🔄",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

    if(shareResult.status == ShareResultStatus.success || shareResult.status == ShareResultStatus.dismissed){
    securityController.startListening();
    }

}

contactClientService() async{
  var contact = "+221778370953";
  var url = "https://wa.me/$contact?text=${Uri.parse('Bonjour Djizhub ')}";

  try{
    await launchUrl(Uri.parse(url));
  } on Exception{
    print('WhatsApp is not installed.');
  }
}

contactCollabo() async{
  var contact = "+221778370953";
  var url = "https://wa.me/$contact?text=${Uri.parse("Bonjour Djizhub je vous contacte à propos d'une collaboration ")}";

  try{
    await launchUrl(Uri.parse(url));
  } on Exception{
    print('WhatsApp is not installed.');
  }
}

visitWebsite() async{
  var url = "https://www.wave.com/fr/";

  try{
    await launchUrl(Uri.parse(url));
  } on Exception{
    print('Erreur d launch');
  }
}