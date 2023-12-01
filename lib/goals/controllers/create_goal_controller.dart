import 'dart:convert';

import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
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

class newGoalModel {

  final String name;
  final String description;
  final double goal;
  final String date_of_withdrawal;
  final bool constraint;


  newGoalModel(
      this.name,this.description,this.goal,this.date_of_withdrawal,this.constraint
      );

}

class CreateGoalController extends GetxController{

  DateTime selectedDate = DateTime.now().add(const Duration(days: 8));
  bool goalConstraint = false;
  CreateGoalState createGoalState = CreateGoalState.PENDING;

  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();

  String backendUrl = "";


  void createNewGoal(BuildContext context,newGoalModel newGoal) async {
    String url = "$backendUrl/goals";

  try{
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    createGoalState = CreateGoalState.LOADING;
    update();
    var response = await http.post(Uri.parse(url),
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
          SnackBar(content: Text("Compte crée avec succés",),backgroundColor: Colors.green,)
      );
        fetchGoalsController.getGoals();
      Get.back();
    } else {
      print("Erreur de requete  lors de la creation du compte ${response.body}");
      createGoalState = CreateGoalState.ERROR;
      update();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
      );
    }
  }catch(err){
    print("Erreur lors de la creation du compte : $err");
    createGoalState = CreateGoalState.SUCCESS;
    update();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Une erreur est survenue, veuillez réessayer SVP",),backgroundColor: Colors.redAccent,)
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

  setGoalConstraint(value){
    goalConstraint = value;
    update();
  }

  setNewUrl(url){
    backendUrl = url;
    update();

  }

}