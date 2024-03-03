import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/controllers/joinGoalController.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/models/member_list_model.dart';
import 'package:djizhub_light/transactions/components/transaction_list.dart';
import 'package:djizhub_light/transactions/controllers/fetch_member_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/goals_model.dart';
class SingleMemberInList extends StatelessWidget {
  FetchMemberController fetchMemberController = Get.find<FetchMemberController>();
  JoinGoalController joinGoalController = Get.find<JoinGoalController>();
  SingleMember member;
   SingleMemberInList(this.member,{super.key});
  var formatter = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: member.name == "Moi" ? const Color(0XFFc4e5e9) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: IntrinsicHeight(
          child: Column(
            children: [
              GestureDetector(
                onTap: ()=>{
                  if(member.transactions!.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Aucune transaction éffectuée pour le moment"),backgroundColor: Colors.grey,)
                    )
                  }else{
                    Get.to(()=>TransactionList(member))
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.3,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member.name ?? "",overflow: TextOverflow.ellipsis,),
                            const SizedBox(height: 10,),
                            member.out ?? false ?
                            const Text("Inactif",style: TextStyle(color: Colors.red)) :
                            const Text("Actif",style: TextStyle(color: Colors.green),)
                          ],
                        ),
                      ),
                      SizedBox(

                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("${member.count} transaction(s)",style: const TextStyle(fontWeight: FontWeight.bold),),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text("${formatter.format(member.total)} Fcfa",style: TextStyle(color: apCol),),
                                    const Text(" au total"),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.circular(50)),
                                    width: 20,
                                    height: 20,
                                    child: const Icon(Icons.arrow_forward_ios,size: 12,color: Colors.white,),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ),
              member.disjoinable ?? false ?
              const Padding(
                padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                child: Divider(height: 0.01,),
              ) : const SizedBox(),
              member.disjoinable ?? false ?
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.remove_circle_outline),
                  const SizedBox(width: 5,),
                  GestureDetector(
                      onTap: ()async{
                        await _showDeletAccountDialogByAdmin(context,fetchGoalsController.currentGoal.value,member.id ?? "",member.name ?? "");


                      },
                      child: const Text('Retirer',style: TextStyle(color: Colors.red),)),
                ],
              ) : const SizedBox()

            ],
          ),
        ),
      ),
    );
  }
}
Future<void> _showDeletAccountDialogByAdmin(BuildContext context,Goal goal,String userId,String userName) async {

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return GetBuilder<JoinGoalController>(

          builder:(value)=> AlertDialog(
            title: const Text('Retrait du coffre'),
            content:  SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Êtes-vous certain de vouloir retirer $userName de ce coffre ?'),
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
                  joinGoalController.disjoinGoalByAdmin(context, goal,userId);

                },
              ),
            ],
          ));
    },
  );
}