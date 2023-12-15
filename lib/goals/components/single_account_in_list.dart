
import 'package:circulito/circulito.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/home/info_box.dart';
import 'package:djizhub_light/models/goals_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import 'account_details.dart';
class SingleAccountInList extends StatelessWidget {
  Goal currentGoal;
   SingleAccountInList({Key? key,required this.currentGoal}) : super(key: key);
   FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Stack(
        children: [

          Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: ()=> {
               fetchGoalsController.setCurrentGoal(currentGoal),
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AccoutDetails()))
            },
            child: Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: MediaQuery.of(context).size.width*0.7,
            decoration: BoxDecoration(
            //  backgroundBlendMode: BlendMode.overlay,
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                /*
                currentGoal.foreign_account! ?
                BoxShadow(

                  color: Colors.grey.shade300,
                  spreadRadius: 1,
                  blurRadius: 20,
                  offset: const Offset(2, 0),
                ):

                   */
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 1,
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 25.0,bottom: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(currentGoal.name?.toUpperCase() ?? "",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.black54),),
                                currentGoal.withdrawable == true || currentGoal.status == "WITHDRAWN"  ?
                                 SizedBox() :
                                 Padding(
                                  padding:  EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.lock_rounded,size: 16,color: lightGrey,),
                                )
                              ],
                            ),
                            Text("Échéance : ${currentGoal.dateOfWithdrawal?.day.toString().padLeft(2, '0')}/${currentGoal.dateOfWithdrawal?.month.toString().padLeft(2, '0')}/${currentGoal.dateOfWithdrawal?.year}",style: TextStyle(fontWeight: FontWeight.bold,color: lightGrey)),
                          ],
                        ),


                        Container(
                          width: 50,
                          height: 50,
                          /*
                          decoration: BoxDecoration(
                            color: apCol,
                            borderRadius: BorderRadius.circular(15)
                          ),

                           */
                     //     child: Icon(Icons.money,color: Colors.white,),

                          child:  Circulito(
                            background: CirculitoBackground(
                              decoration: const CirculitoDecoration.fromColor(Colors.black12),
                            ) ,
                            child: Text("${currentGoal.percent_progress}%"),

                            animation: CirculitoAnimation(
                              duration: 600,
                              curve: Curves.easeInOut,
                            ),
                            strokeWidth: 5,
                            maxSize: 50,
                            sections: [
                              // One single section at 50%.
                              CirculitoSection(

                                value: (double.parse(currentGoal.percent_progress.toString())/100),
                             //   decoration: CirculitoDecoration.fromColor(fetchGoalsController.getColorFromValue(currentGoal.percent_progress!.toInt() ?? 0)),
                                decoration: CirculitoDecoration.fromColor(fetchGoalsController.getColorFromValue(currentGoal.percent_progress ?? 0)),
                              )
                            ],
                          ),

                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoBox(title: "Solde",price: double.parse(currentGoal.balance.toString()) ?? 0.0,designShadow: false,),
                      InfoBox(title: "Objectif",price: double.parse(currentGoal.goal.toString()) ?? 0.0,designShadow: false,),
                    ],
                  ),

                ],
              ),
            ),
                      ),
          ),
        ),
          currentGoal.foreign_account! ?
          Positioned(
            right: 0,
            top: 5,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(25/360),
              child: Container(
                decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 3.0,bottom: 3.0),
                  child: Text("invité",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ) : const SizedBox(),
        ],
      ),
    );
  }
}
