import 'dart:convert';

import 'package:djizhub_light/goals/components/informations.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/models/Single_goal_model.dart';
import 'package:djizhub_light/models/goals_model.dart';
import 'package:djizhub_light/transactions/controllers/fetch_member_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../globals.dart';

enum JoinGoalState {
  PENDING,LOADING,ERROR,SUCCESS

}

enum DisjoinGoalState {
  PENDING,LOADING,ERROR,SUCCESS

}


class JoinGoalController extends GetxController{
  JoinGoalState joinGoalState = JoinGoalState.PENDING;
  DisjoinGoalState disjoinGoalState = DisjoinGoalState.PENDING;
  bool anonymousDeposit = false;
  FetchMemberController fetchMemberController = Get.find<FetchMemberController>();
  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();


  String backendUrl = appUrl;


  void joinGoal(BuildContext context,String goalCode,String nameToSend,String numeroTel) async {
    String url = "$backendUrl/goals/$goalCode/join";
    var response;

    try{
      final user = FirebaseAuth.instance.currentUser!;
      final idToken = await user.getIdToken();
      joinGoalState = JoinGoalState.LOADING;
      update();
      print("Name to sennnnnnnnnnddddd : $nameToSend");
      response = await http.patch(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode({
            "name": nameToSend,
            "phone_number":numeroTel
          }));

      if (response.statusCode == 200) {
        joinGoalState = JoinGoalState.SUCCESS;
        print(response.body);

        //fetchGoalsController.addNewGoal(goalFromJson(response.body));
        update();
        print("Successfully Joined");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Coffre ajouté avec succés",),backgroundColor: Colors.green,)
        );
        fetchGoalsController.getGoals();
        Get.back();
        //  Get.to(()=>Informations());
      } else {
        print("Erreur de requete  lors de rejoindre coffre ${response.body}");
        joinGoalState = JoinGoalState.ERROR;
        update();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
        );
      }
    }catch(err){
      print("Erreur lors de la creation du compte : $err");
      joinGoalState = JoinGoalState.ERROR;
      update();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
      );
    }
  }

  void disjoinGoal(BuildContext context,Goal goal,String userId) async {
    String url = "$backendUrl/goals/${goal.code}/$userId/disjoin";
    var response;

    try{
      final user = FirebaseAuth.instance.currentUser!;
      final idToken = await user.getIdToken();
      disjoinGoalState = DisjoinGoalState.LOADING;
      update();
      response = await http.patch(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $idToken',
        },);

      if (response.statusCode == 200) {
        disjoinGoalState = DisjoinGoalState.SUCCESS;
        print(response.body);

        //fetchGoalsController.addNewGoal(goalFromJson(response.body));
        update();
        print("Successfully Joined");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Succés",),backgroundColor: Colors.green,)
        );
        fetchGoalsController.getGoals();
        Get.back();
        Get.back();
        //  Get.to(()=>Informations());
      } else {
        print("Erreur de requete  lors de rejoindre coffre ${response.body}");
        disjoinGoalState = DisjoinGoalState.ERROR;
        update();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
        );
      }
    }catch(err){
      print("Erreur lors de la creation du compte : $err");
      disjoinGoalState = DisjoinGoalState.ERROR;
      update();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
      );
    }
  }
  void disjoinGoalByAdmin(BuildContext context,Goal goal,String userId) async {
    String url = "$backendUrl/goals/${goal.code}/$userId/disjoin";
    var response;

    try{
      final user = FirebaseAuth.instance.currentUser!;
      final idToken = await user.getIdToken();
      disjoinGoalState = DisjoinGoalState.LOADING;
      update();
      response = await http.patch(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $idToken',
        },);

      if (response.statusCode == 200) {
        disjoinGoalState = DisjoinGoalState.SUCCESS;
        print(response.body);

        //fetchGoalsController.addNewGoal(goalFromJson(response.body));
        update();
        print("Successfully Joined");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Succés",),backgroundColor: Colors.green,)
        );
        fetchMemberController.fetchMembersFromApi(goal.id ?? "");
        Get.back();
        //  Get.to(()=>Informations());
      } else {
        print("Erreur de requete  lors de rejoindre coffre ${response.body}");
        disjoinGoalState = DisjoinGoalState.ERROR;
        update();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
        );
      }
    }catch(err){
      print("Erreur lors de la creation du compte : $err");
      disjoinGoalState = DisjoinGoalState.ERROR;
      update();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
      );
    }
  }

  setAnonymousDeposit(bool isAnonym){
    anonymousDeposit = isAnonym;
    update();
  }


}