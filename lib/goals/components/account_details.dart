
import 'dart:ffi';

import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/home/actions_box.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/home/info_box.dart';
import 'package:djizhub_light/transactions/components/deposit.dart';
import 'package:djizhub_light/transactions/components/setting.dart';
import 'package:djizhub_light/transactions/components/urgence.dart';
import 'package:djizhub_light/transactions/components/withdrawal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import '../../models/goals_model.dart';
import '../../transactions/components/single_transaction.dart';
import '../../transactions/components/transaction_actions.dart';
class AccoutDetails extends StatelessWidget {
  const AccoutDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   /*   floatingActionButton: GestureDetector(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionsActions())),
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
              color: apCol,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Icon(Icons.track_changes),
        ),
      ), */
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Obx(
          ()=>fetchGoalsController.fetchSingleGoalState.value == FetchSingleGoalState.LOADING || fetchGoalsController.fetchSingleGoalState.value == FetchSingleGoalState.PENDING ?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 5,),
                Text("Mis à jour des informations du comptes...")
              ],
            ),
          ) :
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /*     Padding(
                padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap:()=>Navigator.pop(context),
                      child: Container(
                        width: 50,
                          height: 50,
                        decoration: BoxDecoration(
                          color: apCol,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Icon(Icons.clear,),
                      ),
                    ),
                  ],
                ),
              ),*/
              SizedBox(height: 20,),
              Column(
                children: [
                  Text(fetchGoalsController.currentGoal?.value.name ?? "",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  SizedBox(height: 10,),
                  Text("Retrait : ${fetchGoalsController.currentGoal.value.dateOfWithdrawal?.day}/${fetchGoalsController.currentGoal.value.dateOfWithdrawal?.month}/${fetchGoalsController.currentGoal.value.dateOfWithdrawal?.year}",textAlign: TextAlign.center,style: TextStyle(),),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoBox(title: "Solde",price: double.parse(fetchGoalsController.currentGoal.value.balance.toString()) ?? 0.0,designShadow: true,),
                      InfoBox(title: "Objectif",price: double.parse(fetchGoalsController.currentGoal.value.goal.toString()) ?? 0.0,designShadow: true,),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                    child: AbsorbPointer(
                      absorbing: fetchGoalsController.currentGoal.value.status != "OPENED" ? true : false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActionBox(title: "Dépot",backColor: const Color(0xFFD5EDD0),iconColor: Color(0xFF38761D) ,icon: Icons.input,function: ()=>Get.to(()=>Deposit(goalId: fetchGoalsController.currentGoal.value.id ?? "",)),),
                          ActionBox(title: "Retrait",backColor: Color(0xFFFFE4BD),iconColor: Color(0xFFFF9900) ,icon: Icons.output,function: ()=>Get.to(()=>Withdrawal(goalId: fetchGoalsController.currentGoal.value.id ?? "")),),
                          ActionBox(title: "Urgence",backColor: Color(0xFFBFD2E3),iconColor: Color(0xFF0B5394) ,icon: Icons.emergency,function: ()=>Get.to(()=>Urgence()),),
                          ActionBox(title: "Réglages",backColor: Color(0xFFE9CAFF),iconColor: Color(0xFF9900FF) ,icon: Icons.settings,function: ()=>Get.to(()=>Setting()),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 1,
                            blurRadius: 20
                        )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                      child: ListView(
                        children: [
                          Text("Transactions",textAlign: TextAlign.center,style: TextStyle(fontSize:20,color: apCol,fontWeight: FontWeight.bold),),
                          SizedBox(height: 15,),

                          fetchGoalsController.currentGoal.value.transactions!.isEmpty ?
                              Center(child: Text("Aucune Transaction pour le moment, veuillez effectuer un dépot pour économiser.",textAlign: TextAlign.center,)) :
                         Container(
                           child: Column(
                             children: [
                               for(Transaction transaction in fetchGoalsController.currentGoal.value.transactions ?? [])
                                 SingleTransactionInList(transaction: transaction),
                             ],
                           ),
                         )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
