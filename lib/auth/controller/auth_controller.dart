
import 'package:djizhub_light/auth/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthState {
  initial,
  sending,
  codeSent,
  completed,
  failed,
  timeout

}

class AuthController extends GetxController{
  FirebaseAuth auth = FirebaseAuth.instance;

  AuthState authState = AuthState.initial;
  String verify = "";
  String numberToVerify = "";

  setAuthState(AuthState state){
    authState = state;
    update();
  }

  setVerifyId(String verif){
    verify = verif;
    update();
  }

  setNumberToVerify(String number){
    numberToVerify = number;
    update();
  }


  void verifyNumber(String phoneNumber) async{
    setAuthState(AuthState.sending);
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        setAuthState(AuthState.completed);
    },
      verificationFailed: (FirebaseAuthException e) {
        setAuthState(AuthState.failed);
    },
      codeSent: (String verificationId, int? resendToken) {
        setVerifyId(verificationId);
        setAuthState(AuthState.codeSent);
        Get.to(()=>const Otp());
    },
      codeAutoRetrievalTimeout: (String verificationId) {
        setAuthState(AuthState.timeout);
    },
    );

}

  signInWithGoogle(BuildContext context)async{
    
    print("with google");

    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if(googleSignInAccount != null ){
        final GoogleSignInAuthentication googleSignInAuthentication = await
        googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
    //    Navigator.pushNamed(context, "/home");
      }

    }catch(e) {
      print("Erreuuuuuur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur d'authentification, réessayez svp"),backgroundColor: Colors.redAccent,)
      );
    }


  }
}