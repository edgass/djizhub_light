import 'package:djizhub_light/utils/security/security_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';
class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    SecurityController securityController = Get.find<SecurityController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reglage"),
      ),
      body:  IdleDetector(
        idleTime: const Duration(minutes: 1),
        onIdle: () {
          securityController.showOverlay(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(FirebaseAuth.instance.currentUser?.email ?? "",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
             SizedBox(height: 15,),
             Padding(
               padding: const EdgeInsets.only(top: 8.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Général",style: TextStyle(fontSize: 18,color: Colors.black38),),
                   Padding(
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
             )
           ],
                      ),
        ),
      ),
    );
  }
}
