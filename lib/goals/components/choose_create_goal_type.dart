import 'package:djizhub_light/goals/components/single_choose_goal_type.dart';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import 'create_goal.dart';
class ChooseCreateGoalType extends StatelessWidget {
  const ChooseCreateGoalType({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Type de Coffre"),
    ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            const Text("Choisir un type de coffre",style: TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 20,),
            SingleChooseGoalType(GoalType.PRIVATE,'assets/lottie/faible/faible4.json','Epargne',"Pour des économies sécurisées, avec des dates de retrait prédéfinies."),
            const SizedBox(height: 10,),
            SingleChooseGoalType(GoalType.TONTIN,'assets/lottie/faible/faible5.json','Tontine',"Pour des économies collaboratives, avec des versements et retraits collectifs."),
          const SizedBox(height: 10,),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(apCol)),
            onPressed: () {
              Get.to(()=>CreateGoal());
            },
            child: const Text('Suivant',style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }
}
