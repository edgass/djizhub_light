import 'dart:convert';

import 'package:djizhub_light/goals/components/informations.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/models/Single_goal_model.dart';
import 'package:djizhub_light/models/goals_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../globals.dart';

enum CreateGoalState {
  PENDING,LOADING,ERROR,SUCCESS

}

enum UpdateGoalState {
  PENDING,LOADING,ERROR,SUCCESS

}

class newGoalModel {

  final String? id;
  final String name;
  final String description;
  final double goal;
  final String date_of_withdrawal;
  final bool constraint;


  newGoalModel(
      this.id,this.name,this.description,this.goal,this.date_of_withdrawal,this.constraint
      );

}

class CreateGoalController extends GetxController{

  DateTime selectedDate = DateTime.now().add(const Duration(days: 8));
  DateTime selectedUpdateDate = DateTime.now();
  bool goalConstraint = false;
  bool goalConstraintOfUpdate = false;
  CreateGoalState createGoalState = CreateGoalState.PENDING;
  UpdateGoalState updateGoalState = UpdateGoalState.PENDING;

  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();

  String backendUrl = "https://feasible-vocal-gator.ngrok-free.app";


  void createNewGoal(BuildContext context,newGoalModel newGoal) async {
    String url = "$backendUrl/goals";
    var response;

  try{
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    createGoalState = CreateGoalState.LOADING;
    update();
     response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          "name": newGoal.name,
          "description": newGoal.description,
          "goal": newGoal.goal,
          "date_of_withdrawal": newGoal.date_of_withdrawal,
          "constraint": newGoal.constraint,
        }));

    if (response.statusCode == 201) {
      createGoalState = CreateGoalState.SUCCESS;
      print(response.body);

      //fetchGoalsController.addNewGoal(goalFromJson(response.body));
      update();
      print("Compte Crée avec success");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Compte crée avec succés",),backgroundColor: Colors.green,)
      );
        fetchGoalsController.getGoals();
      Get.back();
    //  Get.to(()=>Informations());
    } else {
      print("Erreur de requete  lors de la creation du compte ${response.body}");
      createGoalState = CreateGoalState.ERROR;
      update();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
      );
    }
  }catch(err){
    print("Erreur lors de la creation du compte : $err");
    createGoalState = CreateGoalState.ERROR;
    update();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
    );
  }
  }


  void updateGoal(BuildContext context,newGoalModel newGoal) async {
    String url = "$backendUrl/goals/${newGoal.id}";
    print(newGoal.date_of_withdrawal);
    var response;

    try{
      final user = FirebaseAuth.instance.currentUser!;
      final idToken = await user.getIdToken();
      updateGoalState = UpdateGoalState.LOADING;
      update();
      response = await http.patch(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode({
            "name": newGoal.name,
            "description": newGoal.description,
            "goal": newGoal.goal,
            "date_of_withdrawal": selectedUpdateDate.toIso8601String(),
            "constraint": goalConstraintOfUpdate,
          }));

      if (response.statusCode == 200) {
        updateGoalState = UpdateGoalState.SUCCESS;
        print(singleGoalsFromJson(response.body).data);

        //fetchGoalsController.addNewGoal(goalFromJson(response.body));
        update();
        print("Compte Crée avec success");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Votre compte Epargne a été mis à jour avec succés",),backgroundColor: Colors.green,)
        );
        fetchGoalsController.setCurrentGoal((singleGoalsFromJson(response.body).data) ?? Goal());
        fetchGoalsController.getGoals();
        Get.back();
      } else {
        print("Erreur de requete  lors de la creation du compte ${response.body}");
        updateGoalState = UpdateGoalState.ERROR;
        update();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(singleGoalsFromJson(response.body).message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
        );
      }
    }catch(err){
      print("Erreur lors de la creation du compte : $err");
      updateGoalState = UpdateGoalState.ERROR;
      update();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(singleGoalsFromJson(response.body ?? "").message ?? "Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
      );
    }
  }


  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().add(const Duration(days: 7)),
        lastDate: DateTime(2050));
    if (picked != null) {
      selectedDate = picked;

    }
    print(selectedDate);
    update();
  }

  selectUpdateDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedUpdateDate,
        firstDate: selectedUpdateDate,
        lastDate: DateTime(2050));
    if (picked != null) {
      selectedUpdateDate = picked;

    }
    print(selectedDate);
    update();
  }

  setInitialUpdateDate(DateTime date){
    selectedUpdateDate = date;
  }

  setGoalConstraint(value){
    goalConstraint = value;
    update();
  }

  setUpdateGoalConstraint(bool value){
    goalConstraintOfUpdate = value;
    update();
  }

  setNewUrl(url){
    backendUrl = url;
    update();

  }

}