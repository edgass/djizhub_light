
import 'dart:ffi';

import 'package:djizhub_light/goals/components/informations.dart';
import 'package:djizhub_light/goals/components/member_list.dart';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/goals/controllers/joinGoalController.dart';
import 'package:djizhub_light/home/actions_box.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/home/info_box.dart';
import 'package:djizhub_light/transactions/components/deposit.dart';
import 'package:djizhub_light/transactions/components/accountSetting.dart';
import 'package:djizhub_light/transactions/components/withdrawal.dart';
import 'package:djizhub_light/transactions/controllers/fetch_member_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../globals.dart';
import '../../models/goals_model.dart';
import '../../transactions/components/single_transaction.dart';
class AccoutDetails extends StatelessWidget {
  const AccoutDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateGoalController createGoalController = Get.find<CreateGoalController>();
    JoinGoalController joinGoalController = Get.find<JoinGoalController>();
    FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
    FetchMemberController fetchMemberController = Get.find<FetchMemberController>();

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
            SizedBox(height: 12,),
            Column(
              children: [
                Text(fetchGoalsController.currentGoal?.value.name?.toUpperCase() ?? "",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                SizedBox(height: 10,),
                fetchGoalsController.currentGoal.value.type == GoalType.PRIVATE.name ?
                Text("Échéance : ${fetchGoalsController.currentGoal.value.dateOfWithdrawal?.day.toString().padLeft(2, '0')}/${fetchGoalsController.currentGoal.value.dateOfWithdrawal?.month.toString().padLeft(2, '0')}/${fetchGoalsController.currentGoal.value.dateOfWithdrawal?.year}",textAlign: TextAlign.center,style: TextStyle(),)
                :Text("Nombre de participants : ${fetchGoalsController.currentGoal.value.subscribers}"),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InfoBox(title: "Solde",price: double.parse(fetchGoalsController.currentGoal.value.balance.toString()) ?? 0.0,designShadow: true,),
                    InfoBox(title: "Objectif",price: double.parse(fetchGoalsController.currentGoal.value.goal.toString()) ?? 0.0,designShadow: true,),
                  ],
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                  child: AbsorbPointer(
                    absorbing: fetchGoalsController.currentGoal.value.status != "OPENED" ? true : false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Opacity(
                            opacity:fetchGoalsController.currentGoal.value.status == "OPENED" ? 1 : 0.4,
                            child: ActionBox(title: "Dépot",backColor:  const Color(0xFFD5EDD0),iconColor:Color(0xFF38761D),icon: Icons.input,function: fetchGoalsController.currentGoal.value.status == "OPENED" || !fetchGoalsController.currentGoal.value.foreign_account! ? ()=>Get.to(()=>Deposit(goalId: fetchGoalsController.currentGoal.value.id ?? "",)): (){},)),
                        Opacity(
                            opacity: fetchGoalsController.currentGoal.value.withdrawable == true && fetchGoalsController.currentGoal.value.foreign_account! == false ? 1 : 0.4,
                            child: ActionBox(title: "Retrait",backColor: Color(0xFFFFE4BD),iconColor:Color(0xFFFF9900),icon: Icons.output,function:fetchGoalsController.currentGoal.value.withdrawable == true && fetchGoalsController.currentGoal.value.foreign_account == false ? ()=>{
                              Get.to(()=>Withdrawal(goalId: fetchGoalsController.currentGoal.value.id ?? "",emergency: false,)),
                              if(securityController.canAskPin){
                                securityController.startTimer(),
                                securityController.showOverlay(context)
                              }

                            }: (){},)),
                      fetchGoalsController.currentGoal.value.listable ?? true ?
                      ActionBox(title: "Liste",backColor: Color(0xFFdfe3ee),iconColor:Color(0xFF8b9dc3),icon: Icons.list_alt_outlined,function:()=>{
                            fetchMemberController.fetchMembersFromApi(fetchGoalsController.currentGoal.value.id ?? ''),
                            Get.to(()=>MemberList())
                      },) :
                      Opacity(
                          opacity: (fetchGoalsController.currentGoal.value.status == "OPENED" && fetchGoalsController.currentGoal.value.emmergency_withdrawal == true) && fetchGoalsController.currentGoal.value.foreign_account! == false ? 1 : 0.4,
                          child:  ActionBox(title: "Urgence",backColor: Color(0xFFFFCCCC),iconColor:Color(0xFFFF4C4C),icon: Icons.emergency,function:(fetchGoalsController.currentGoal.value.status == "OPENED" && fetchGoalsController.currentGoal.value.emmergency_withdrawal == true) && fetchGoalsController.currentGoal.value.foreign_account! == false ? ()=>{
                            Get.to(()=>Withdrawal(goalId: fetchGoalsController.currentGoal.value.id ?? "",emergency: true,)),
                            if(securityController.canAskPin){
                              securityController.startTimer(),
                              securityController.showOverlay(context)
                            }
                          }: (){},)),
                        Opacity(
                            opacity: fetchGoalsController.currentGoal.value.status == "OPENED" && fetchGoalsController.currentGoal.value.foreign_account! == false ? 1 : 0.4,
                            child: ActionBox(title: "Réglages",backColor: Color(0xFFE9CAFF),iconColor: Color(0xFF9900FF),icon: Icons.settings,function:fetchGoalsController.currentGoal.value.status == "OPENED" && fetchGoalsController.currentGoal.value.foreign_account! == false ?  ()=>{
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
                    padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                    child: Column(
                      children: [
                        Text("Transactions",textAlign: TextAlign.center,style: TextStyle(fontSize:20,color: apCol,fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),

                        fetchGoalsController.currentGoal.value.transactions!.isEmpty ?
                            Center(child: Text("Aucune Transaction pour le moment, veuillez effectuer un dépot pour économiser.",textAlign: TextAlign.center,)) :
                       Expanded(
                         child: ListView.separated(
                           itemCount: fetchGoalsController.currentGoal.value.transactions!.length,
                           separatorBuilder: (BuildContext context, int index) =>
                               const SizedBox(height: 10.0,),
                           itemBuilder: (BuildContext context, int index) {
                             Transaction transaction = fetchGoalsController.currentGoal.value.transactions![index];
                             return SingleTransactionInList(
                               transaction: transaction,
                             );
                           },
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

  shareResult = await Share.shareWithResult("Pour rejoindre le coffre, veuillez entrer le code suivant : ${fetchGoalsController.currentGoal.value.code} ou cliquez tout simplement sur le lien suivant : https://djizhub.com/",
      subject: "Invitation à rejoindre le coffre ${fetchGoalsController.currentGoal.value.name}! 💰🔄",
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
      return GetBuilder<JoinGoalController>(

          builder:(value)=> AlertDialog(
        title: const Text('Retrait du coffre'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Êtes-vous certain de vouloir retirer ce coffre de votre liste de comptes'),
            ],
          ),
        ),
        actions: <Widget>[
          value.disjoinGoalState == DisjoinGoalState.LOADING ? const SizedBox():
          TextButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          value.disjoinGoalState == DisjoinGoalState.LOADING ? const CircularProgressIndicator():
          TextButton(
            child: const Text('Retirer',style: TextStyle(color: Colors.deepOrangeAccent),),
            onPressed: () {
              joinGoalController.disjoinGoal(context, fetchGoalsController.currentGoal.value.code!);
            },
          ),
        ],
      ));
    },
  );
}


void showMoreMenu(BuildContext context) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(300, 80, 0, 0), // Ajuste la position du menu
    items: [
      if(fetchGoalsController.currentGoal.value.type == GoalType.PRIVATE.name)
      PopupMenuItem(
        child: Text('Recommandations'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  Informations()));
        },
      ),
      if(fetchGoalsController.currentGoal.value.type == GoalType.TONTIN.name)
      PopupMenuItem(
        child: Text('Partager le coffre'),
        onTap: () {
          _onShareAccount(context);
        },
      ),
      if(fetchGoalsController.currentGoal.value.foreign_account!)
      PopupMenuItem(
        child: Text('Retirer le coffre'),
        onTap: () {
          _showDeletAccountDialog(context);
        },
      ),
      // Ajoute autant d'items que nécessaire
    ],
  );
}
