
import 'dart:async';

import 'package:djizhub_light/auth/otp.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/home/home_check.dart';
import 'package:djizhub_light/utils/security/security_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

import '../../home/home.dart';


enum AuthState {
  initial,
  sending,
  codeSent,
  completed,
  failed,
  timeout

}

enum MyconnexionState {
  noInternet,
  backToInternet,
  idle,
}



class AuthController extends GetxController{
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();
  String? userName;
  Rx<MyconnexionState> myConnexionState = Rx<MyconnexionState>(MyconnexionState.idle);
  late final _connectivitySubscription;


  @override
  void onInit() {
    // TODO: implement onInit
    final subscription =
    InternetConnectivity().observeInternetConnection.listen((bool hasInternetAccess) {
      if(!hasInternetAccess){
        print('No Internet Connection');
        myConnexionState.value = MyconnexionState.noInternet;
      }else{
        print("De retour sur internet");

        myConnexionState.value = MyconnexionState.backToInternet;

        Future.delayed(const Duration(seconds: 2), () {
          myConnexionState.value = MyconnexionState.idle;
        });
        FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
        fetchGoalsController.getGoals();
      }
    });
    storage.read(key: 'name').then((value) => userName = value);
  }



  String? creatingPin;
  String? confirmingPin;
  String? currentPin;

  AuthState authState = AuthState.initial;
  String verify = "";
  String numberToVerify = "";

  DatabaseReference dbRef =
  FirebaseDatabase.instance.ref().child("Users");


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

  setCreatingPin(String pin){
    creatingPin = pin;

  }

  setConfirmCreatingPin(String pin){
    confirmingPin = pin;

  }

  Future setPinInCache(String pin) async{
    await storage.write(key: "pin", value: pin);
  }

  Future getPinInCache() async{
    return await storage.read(key: 'pin') ?? "N/A";
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


    final GoogleSignIn _googleSignIn = GoogleSignIn();

    await FirebaseAuth.instance.signOut();

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
        Get.offAll(()=>HomeCheck());
      }

    }catch(e) {
      print("Erreuuuuuur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur d'authentification, réessayez svp"),backgroundColor: Colors.redAccent,)
      );
    }


  }

  addPinToFirebase () async{
    try{
      DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child("Users");

      dbRef.child(FirebaseAuth.instance.currentUser!.uid).update({
        "pin": confirmingPin,
      }).then((res) async {
        await storage.write(key: 'pin', value: confirmingPin);
        securityController.setCurrentPin(confirmingPin);
       Get.offAll(Home());
       creatingPin = null;
       confirmingPin = null;

      });


    }catch(e){
      print(e);
    }
  }


  Future <String?> searchPinInCache() async{
    String? value = await storage.read(key: 'pin');
    print("pin retrouvé dans cache : $value");
      return value;
  }


  Stream<String?> fetchUserPin(String userId) async* {
    print(userId);
    final controller = StreamController<String?>();

    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('Users/$userId').get();
      print(snapshot.value);
      if (snapshot.exists) {
        final dynamic value = snapshot.value;
        if (value != null && value is Map<Object?, Object?>) {
          print('Contenu de la map : $value');
          final pin = value['pin'] as String?;
          if (pin != null) {
            storage.write(key: 'pin', value: pin);
            controller.add(pin);
          } else {
            controller.addError("Pin n'existe pas");
          }
        } else {
          controller.addError('La valeur du snapshot est invalide.');
        }
        controller.close(); // Fermer le flux après avoir émis la valeur ou une erreur
      } else {
        controller.addError('L\'utilisateur avec l\'ID $userId n\'existe pas.');
        controller.close(); // Fermer le flux en cas d'erreur
      }
    } catch (e) {
      controller.addError('Erreur lors de la récupération du pin de l\'utilisateur: $e');
      controller.close(); // Fermer le flux en cas d'erreur
    }

    yield* controller.stream;
  }

  Future<String?> fetchUserName(String userId) async{
    print(userId);

    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('Users/$userId').get();
      print(snapshot.value);
      if (snapshot.exists) {
        final dynamic value = snapshot.value;
        if (value != null && value is Map<Object?, Object?>) {
          print('Contenu de la map : $value');
          final name = value['name'] as String?;
          if (name != null) {
            storage.write(key: 'name', value: name);
            userName = name;
            return name;
          } else {
            print("Valeur nom n'existe pas pour cet utilisateur");
          }
        } else {
          print('La valeur du snapshot est invalide.');
        }
      } else {
        print("Document inexistant");
        return null;
      }
    } catch (e) {
     print("erreur lors de la recuperation du nom depuis firebase Database : $e");
    }
  }


setUserName(String name){
    userName = name;
}

}