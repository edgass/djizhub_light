import 'package:djizhub_light/goals/components/single_choose_goal_type.dart';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import '../../globals.dart';
import 'create_goal.dart';
class ChooseCreateGoalType extends StatelessWidget {
  const ChooseCreateGoalType({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Type de Coffre"),
    ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Text("Choisir un type de compte",style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
            SingleChooseGoalType(GoalType.PRIVATE,'assets/lottie/faible/faible4.json','Epargne','Pour que vous puissiez epargner'),
            SizedBox(height: 10,),
            SingleChooseGoalType(GoalType.TONTIN,'assets/lottie/faible/faible5.json','Tontine','Pour que vous faites des cotisations en groupe'),
          SizedBox(height: 10,),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(apCol)),
            onPressed: () {
              Get.to(()=>CreateGoal());
            },
            child: Text('Suivant',style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }
}
