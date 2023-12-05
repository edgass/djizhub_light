import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/utils/loading.dart';
import 'package:djizhub_light/utils/security/create_pin.dart';
import 'package:djizhub_light/utils/security/enter_pin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
class HomeCheck extends StatelessWidget {
  const HomeCheck({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();

    final storage = const FlutterSecureStorage();
    return StreamBuilder<String?>(
        stream: authController.fetchUserPin(FirebaseAuth.instance.currentUser?.uid ?? ""),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Pendant le chargement
            return Loading();
          } else if (snapshot.hasError) {
            // En cas d'erreur
            return CreatePin();
          } else if (!snapshot.hasData) {
            // Si les données sont nulles (peut se produire si l'utilisateur n'existe pas)
            return CreatePin();
          } else {
            // Afficher le PIN
            storage.write(key: 'pin', value: snapshot.data);
            print("ya pin");
            return EnterPin(rightPin: snapshot.data ?? "" ,);
          }
        });
  }
}
