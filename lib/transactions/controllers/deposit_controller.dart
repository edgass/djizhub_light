import 'dart:convert';

import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/models/Single_goal_model.dart';
import 'package:djizhub_light/models/error_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../goals/controllers/create_goal_controller.dart';
import '../../models/goals_model.dart';

enum Operator{
  OM,WAVE,FREE
}

enum MakeTransactionState {
  PENDING,LOADING,ERROR,SUCCESS

}

class newTransactionModel {

  final String? phone_number;
  final String? operator;
  final double? amount;
  final String? otp;
  final bool? emergency;


  newTransactionModel(
      this.phone_number,this.operator,this.amount,this.otp,this.emergency
      );

}

class DepositController extends GetxController{

  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
  CreateGoalController createGoalController = Get.find<CreateGoalController>();
  Operator operator = Operator.WAVE;
  MakeTransactionState makeTransactionState = MakeTransactionState.PENDING;
  bool acceptEmmergencyTerm = false;


  setOperator(Operator op){
    operator = op;
    update();
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
      makeTransactionState = MakeTransactionState.LOADING;
      update();
       response = await http.patch(Uri.parse("$url/$goalId/deposit"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode({
            "phone_number": transaction.phone_number,
            "operator": transaction.operator,
            "amount": transaction.amount,
            "otp": transaction.otp,
          }));
  print(response.statusCode);
      if (response.statusCode == 200) {
        makeTransactionState = MakeTransactionState.SUCCESS;
        update();
        print("Dépot réalisé avec succés");
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Dépot réalisé avec succés",),backgroundColor: Colors.green,)
        );

        var goal = singleGoalsFromJson(response.body).data;
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
            SnackBar(content: Text("Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
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
      makeTransactionState = MakeTransactionState.LOADING;
      update();
       response = await http.patch(Uri.parse("$url/$goalId/withdrawal"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode({
            "phone_number": transaction.phone_number,
            "operator": transaction.operator,
            "emergency":transaction.emergency
          }));
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
            SnackBar(content:Text(error.message ?? "Une erreur est survenue, veuillez réessayer"),backgroundColor: Colors.redAccent,)
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
  
}