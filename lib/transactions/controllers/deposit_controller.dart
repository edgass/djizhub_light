import 'dart:convert';
import 'dart:math';

import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/models/Single_goal_model.dart';
import 'package:djizhub_light/models/error_model.dart';
import 'package:djizhub_light/models/transaction_response_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../goals/controllers/create_goal_controller.dart';
import '../../models/goals_model.dart';

enum Operator{
  OM,WAVE,FREE
}

enum MakeTransactionState {
  PENDING,LOADING,ERROR,SUCCESS

}

class newTransactionModel {

  final bool? secret;
  final String? phone_number;
  final String? operator;
  final double? amount;
  final String? otp;
  final bool? emergency;
  final String? note;


  newTransactionModel(
      this.secret,this.phone_number,this.operator,this.amount,this.otp,this.emergency,this.note
      );

}

class DepositController extends GetxController{

  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
  CreateGoalController createGoalController = Get.find<CreateGoalController>();
  AuthController authController = Get.find<AuthController>();
  Operator operator = Operator.WAVE;
  MakeTransactionState makeTransactionState = MakeTransactionState.PENDING;
  bool acceptEmmergencyTerm = false;
  final firebaseMessaging = FirebaseMessaging.instance;

  String? nameToSend;

  setNameToSend(String newName){
    nameToSend = newName;
    update();
  }


  setOperator(Operator op){
    operator = op;
    update();
  }

  int generateRandomNotificationId() {
    final random = Random();
    return random.nextInt(100000);
  }


  setAcceptEmmergencyTerm(bool accept){
    acceptEmmergencyTerm = accept;
    update();
  }

  makeDeposit(BuildContext context,newTransactionModel transaction,String goalId) async {
    String url = "${createGoalController.backendUrl}/goals";

    var response;
    try{
      final user = FirebaseAuth.instance.currentUser!;
      final idToken = await user.getIdToken();
     // final fcmToken = await firebaseMessaging.getToken();
      makeTransactionState = MakeTransactionState.LOADING;
      update();
       response = await http.patch(Uri.parse("$url/$goalId/deposit"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $idToken',
            'fcm-token':authController.fcmToken ?? "",
          },
          body: jsonEncode({
            "secret": transaction.secret,
            "phone_number": transaction.phone_number,
            "operator": transaction.operator,
            "amount": transaction.amount,
            "otp": transaction.otp,
          })).timeout(
         const Duration(seconds: 5),
         onTimeout: () {
           // Time has run out, do what you wanted to do.
           return http.Response('Error', 408); // Request Timeout response status code
         },
       );
  print(response.statusCode);
      if (response.statusCode == 200) {
        makeTransactionState = MakeTransactionState.SUCCESS;
        update();
        print("Dépot réalisé avec succés");
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Dépot réalisé avec succés",),backgroundColor: Colors.green,)
        );
        var waveUrl = transactionResponseModelFromJson(response.body).data?.launchUrl;
        await launchWaveUrl(waveUrl.toString());

        print("Repoooooooooooooooooooooooooooooonse : "+waveUrl.toString());


    //  fetchGoalsController.setCurrentGoal(goal!);
   //   fetchGoalsController.getGoals();

     //   print(singleGoalsFromJson(response.body));
       // fetchGoalsController.setCurrentGoal(goalsFromJson(response.body).data![0]);
        Get.back();
      } else {
        print("Erreur de requete  lors du dépot ${response.body}");
        makeTransactionState = MakeTransactionState.ERROR;
        update();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:  Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
        );
      }
    }catch(err){
      print("Erreur lors de la creation du compte 2 : $err");
      makeTransactionState = MakeTransactionState.ERROR;
      update();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
      );
    }
  }

  makeWithdrawal(BuildContext context,newTransactionModel transaction,String goalId) async {
    String url = "${createGoalController.backendUrl}/goals";
    var response;
    try{
      final user = FirebaseAuth.instance.currentUser!;
      final idToken = await user.getIdToken();
    //  final fcmToken = await firebaseMessaging.getToken();
      makeTransactionState = MakeTransactionState.LOADING;
      update();
       response = await http.patch(Uri.parse("$url/$goalId/withdrawal"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $idToken',
            'fcm-token':authController.fcmToken ?? "",
          },
          body: jsonEncode({
            "secret": transaction.secret,
            "phone_number": transaction.phone_number,
            "operator": transaction.operator,
            "emergency":transaction.emergency,
            "amount":transaction.amount,
            "note":transaction.note
          })).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response('Error', 408); // Request Timeout response status code
        },
      );;
      print(response.statusCode);
      if (response.statusCode == 200) {

        makeTransactionState = MakeTransactionState.SUCCESS;
        update();
        print("Retrait réalisé avec succés");
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Retrait en cours de réalisation"),backgroundColor: Colors.green,)
        );

        var goal = singleGoalsFromJson(response.body).data;
     //    await fetchGoalsController.setCurrentGoal(goal!);




        //   print(singleGoalsFromJson(response.body));
        // fetchGoalsController.setCurrentGoal(goalsFromJson(response.body).data![0]);
        Get.back();
      } else {
        print("Erreur de requete  lors du dépot ${response.body}");
        makeTransactionState = MakeTransactionState.ERROR;
        update();
        var error = errorTypeFromJson(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer"),backgroundColor: Colors.redAccent,)
        );
      }

    }catch(err){
      print("Erreur lors du retrait : $err");
      makeTransactionState = MakeTransactionState.ERROR;
      update();
       var error = errorTypeFromJson(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? "Une erreur est survenue, veuillez réessayer"),backgroundColor: Colors.redAccent,)
      );
    }
  }

  launchWaveUrl(String waveUrl) async{

    try{
      await launchUrl(Uri.parse(waveUrl));
    } on Exception{
      print('Erreur d launch');
    }
  }
  
}