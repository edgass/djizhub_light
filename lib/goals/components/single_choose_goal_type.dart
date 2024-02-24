import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
class SingleChooseGoalType extends StatelessWidget {
  GoalType goalType;
  String lootieFileName;
  String title;
  String contentText;
   SingleChooseGoalType(this.goalType,this.lootieFileName,this.title,this.contentText,{super.key});

   CreateGoalController createGoalController = Get.find<CreateGoalController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateGoalController>(builder: (value)=>InkWell(
      onTap: ()=>createGoalController.setCreateGoalType(goalType),
      child: Container(
        height: MediaQuery.of(context).size.width*0.3,
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            border: value.goalType == goalType ? Border.all(color: Colors.blueAccent) : null
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.3,

              child: Lottie.asset(lootieFileName,fit: BoxFit.contain),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.4,

              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  Text(contentText
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
