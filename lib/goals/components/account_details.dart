
import 'dart:ffi';

import 'package:djizhub_light/goals/components/informations.dart';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/home/actions_box.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/home/info_box.dart';
import 'package:djizhub_light/transactions/components/deposit.dart';
import 'package:djizhub_light/transactions/components/accountSetting.dart';
import 'package:djizhub_light/transactions/components/urgence.dart';
import 'package:djizhub_light/transactions/components/withdrawal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../globals.dart';
import '../../models/goals_model.dart';
import '../../transactions/components/single_transaction.dart';
import '../../transactions/components/transaction_actions.dart';
class AccoutDetails extends StatelessWidget {
  const AccoutDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateGoalController createGoalController = Get.find<CreateGoalController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showMoreMenu(context);
            },
          ),
        ],
      ),
      /*
      floatingActionButton: GestureDetector(
        onTap: ()=>
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  Informations()))
        },
        child: Icon(Icons.info,size: 50,color: lightGrey,),
      ),
       */
      body: Obx(
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
                Text(fetchGoalsController.currentGoal?.value.name?.toUpperCase() ?? "",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                SizedBox(height: 10,),
                Text("Échéance : ${fetchGoalsController.currentGoal.value.dateOfWithdrawal?.day.toString().padLeft(2, '0')}/${fetchGoalsController.currentGoal.value.dateOfWithdrawal?.month.toString().padLeft(2, '0')}/${fetchGoalsController.currentGoal.value.dateOfWithdrawal?.year}",textAlign: TextAlign.center,style: TextStyle(),),
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
                        Opacity(
                            opacity:fetchGoalsController.currentGoal.value.status == "OPENED" ? 1 : 0.4,
                            child: ActionBox(title: "Dépot",backColor:  const Color(0xFFD5EDD0),iconColor:Color(0xFF38761D),icon: Icons.input,function: fetchGoalsController.currentGoal.value.status == "OPENED" ? ()=>Get.to(()=>Deposit(goalId: fetchGoalsController.currentGoal.value.id ?? "",)): (){},)),
                        Opacity(
                            opacity: fetchGoalsController.currentGoal.value.withdrawable == true  ? 1 : 0.4,
                            child: ActionBox(title: "Retrait",backColor: Color(0xFFFFE4BD),iconColor:Color(0xFFFF9900),icon: Icons.output,function:fetchGoalsController.currentGoal.value.withdrawable == true ? ()=>{
                              Get.to(()=>Withdrawal(goalId: fetchGoalsController.currentGoal.value.id ?? "",emergency: false,)),
                              if(securityController.canAskPin){
                                securityController.startTimer(),
                                securityController.showOverlay(context)
                              }

                            }: (){},)),
                        Opacity(
                            opacity: fetchGoalsController.currentGoal.value.status == "OPENED" && fetchGoalsController.currentGoal.value.emmergency_withdrawal == true ? 1 : 0.4,
                            child: ActionBox(title: "Urgence",backColor: Color(0xFFFFCCCC),iconColor:Color(0xFFFF4C4C),icon: Icons.emergency,function:fetchGoalsController.currentGoal.value.status == "OPENED" && fetchGoalsController.currentGoal.value.emmergency_withdrawal == true ? ()=>{
                              Get.to(()=>Withdrawal(goalId: fetchGoalsController.currentGoal.value.id ?? "",emergency: true,)),
                              if(securityController.canAskPin){
                                securityController.startTimer(),
                                securityController.showOverlay(context)
                              }
                            }: (){},)),
                        Opacity(
                            opacity: fetchGoalsController.currentGoal.value.status == "OPENED" ? 1 : 0.4,
                            child: ActionBox(title: "Réglages",backColor: Color(0xFFE9CAFF),iconColor: Color(0xFF9900FF),icon: Icons.settings,function:fetchGoalsController.currentGoal.value.status == "OPENED" ? ()=>{
                              createGoalController.setUpdateGoalConstraint(fetchGoalsController.currentGoal.value.constraint ?? true),
                              createGoalController.setInitialUpdateDate(fetchGoalsController.currentGoal.value.dateOfWithdrawal ?? DateTime.now()),
                              createGoalController.goalConstraintOfUpdate = fetchGoalsController.currentGoal.value.constraint ?? true,
                              Get.to(()=>AccountParameter(goal: fetchGoalsController.currentGoal.value,)),
                              if(securityController.canAskPin){
                                securityController.startTimer(),
                                securityController.showOverlay(context)
                              }
                            }: (){},)),
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
      ),
    );
  }
}



void _onShareAccount(BuildContext context) async {
  ShareResult shareResult;
  securityController.stopListening();

  final box = context.findRenderObject() as RenderBox?;

  shareResult = await Share.shareWithResult("Pour rejoindre le compte, veuillez entrer le code suivant : ${fetchGoalsController.currentGoal.value.code} ou cliquez tout simplement sur le lien suivant : https://djizhub.com/",
      subject: "Invitation à rejoindre le compte ${fetchGoalsController.currentGoal.value.name}! 💰🔄",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

  if(shareResult.status == ShareResultStatus.success || shareResult.status == ShareResultStatus.dismissed){
    securityController.startListening();
  }

}


Future<void> _showDeletAccountDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Retrait du compte'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Êtes-vous certain de vouloir retirer ce compte de votre liste de comptes'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Retirer',style: TextStyle(color: Colors.deepOrangeAccent),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


void showMoreMenu(BuildContext context) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(300, 80, 0, 0), // Ajuste la position du menu
    items: [
      PopupMenuItem(
        child: Text('Recommandations'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  Informations()));
        },
      ),
      PopupMenuItem(
        child: Text('Partager le compte'),
        onTap: () {
          _onShareAccount(context);
        },
      ),
      PopupMenuItem(
        child: Text('Retirer le compte'),
        onTap: () {
          _showDeletAccountDialog(context);
        },
      ),
      // Ajoute autant d'items que nécessaire
    ],
  );
}
