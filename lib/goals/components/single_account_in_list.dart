
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
            backgroundBlendMode: BlendMode.overlay,
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [

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
                          Text(currentGoal.name ?? "",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.black54),),
                          Text("Retrait : ${currentGoal.dateOfWithdrawal?.day}/${currentGoal.dateOfWithdrawal?.month}/${currentGoal.dateOfWithdrawal?.year}",style: TextStyle(fontWeight: FontWeight.bold,color: lightGrey)),
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
                          child: Text("${(((currentGoal.balance! / double.parse(currentGoal.goal.toString())) * 100).toInt()).toString()}%"),

                          animation: CirculitoAnimation(
                            duration: 600,
                            curve: Curves.easeInOut,
                          ),
                          strokeWidth: 5,
                          maxSize: 50,
                          sections: [
                            // One single section at 50%.
                            CirculitoSection(

                              value: (currentGoal.balance! / double.parse(currentGoal.goal.toString())),
                              decoration: const CirculitoDecoration.fromColor(Color(0XFF35BBCA)),
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
    );
  }
}
