

import 'dart:convert';
import 'dart:core';
import 'dart:ffi';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/goals_model.dart';

enum FetchState {
  PENDING,LOADING,ERROR,SUCCESS

}

enum FetchSingleGoalState {
  PENDING,LOADING,ERROR,SUCCESS

}

enum FetchSingleTransactionState {
  PENDING,LOADING,ERROR,SUCCESS

}
CreateGoalController createGoalController = Get.find<CreateGoalController>();


class FetchGoalsController extends GetxController{

 Rx<int> selectedTab = 0.obs;
 RxList<Goal> goals = <Goal>[].obs;
 Rx<Goal> currentGoal = Goal().obs;
 double goalPercentage = 0;
 Transaction currentTransaction = Transaction();
 Rx<FetchState> fetchState = FetchState.PENDING.obs;
 Rx<FetchSingleGoalState> fetchSingleGoalState = FetchSingleGoalState.PENDING.obs;
 FetchSingleTransactionState fetchSingleTransactionState = FetchSingleTransactionState.PENDING;


 @override
  void onInit() {
    // TODO: implement onInit

  }



  void getGoals() async {
    String url = "${createGoalController.backendUrl}/goals";


    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    fetchState.value = FetchState.LOADING;
    update();

    final response = await http.get(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $idToken',
    });


    if (response.statusCode == 200) {
      goals.value = goalsFromJson(response.body).data ?? [];
      fetchState.value = FetchState.SUCCESS;
      update();

    } else {
      fetchState.value = FetchState.ERROR;
      update();
    }
    print(response.statusCode);
  }

  getSingleGoal(String idGoal) async {
   print("executing get goals ");
   String url = "${createGoalController.backendUrl}/goals";


   final user = FirebaseAuth.instance.currentUser!;
   final idToken = await user.getIdToken();
   fetchState.value = FetchState.LOADING;
   update();

   final response = await http.get(Uri.parse("$url/$idGoal"),
       headers: {
         'Content-Type': 'application/json',
         'Accept': 'application/json',
         'Authorization': 'Bearer $idToken',
       });


   if (response.statusCode == 200) {

     print(goalsFromJson(response.body).data) ;
     fetchState.value = FetchState.SUCCESS;
     update();
     print(" get goals executed");

   } else {
     print(response.body);
     fetchState.value = FetchState.ERROR;
     update();
   }
   print(response.statusCode);
 }

 void getSingleTransaction() async {
   String url = "${createGoalController.backendUrl}/goals";


   final user = FirebaseAuth.instance.currentUser!;
   final idToken = await user.getIdToken();
   fetchState.value = FetchState.LOADING;
   update();

   final response = await http.get(Uri.parse(url),
       headers: {
         'Content-Type': 'application/json',
         'Accept': 'application/json',
         'Authorization': 'Bearer $idToken',
       });


   if (response.statusCode == 200) {
     goals.value = goalsFromJson(response.body).data ?? [];
     fetchState.value = FetchState.SUCCESS;
     update();

   } else {
     fetchState.value = FetchState.ERROR;
     update();
   }
   print(response.statusCode);
 }

   setCurrentGoal(Goal goal) {
   currentGoal.value = goal;
   fetchSingleGoalState.value = FetchSingleGoalState.SUCCESS;
   update();
  }

 setCurrentTransaction(Transaction transaction) {
   currentTransaction = transaction;
   fetchSingleTransactionState = FetchSingleTransactionState.SUCCESS;
   update();
 }

 setSelectedTab(int tab){
   selectedTab.value = tab;
 }

}