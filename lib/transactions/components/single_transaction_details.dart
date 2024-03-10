import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/models/goals_model.dart';
import 'package:djizhub_light/transactions/components/single_validator_in_list.dart';
import 'package:djizhub_light/transactions/components/validators_list.dart';
import 'package:djizhub_light/utils/security/security_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../home/home.dart';
import '../controllers/deposit_controller.dart';
class SingleTransactionDetails extends StatelessWidget {
  var formatter = NumberFormat("#,###");
  Transaction transaction;
   SingleTransactionDetails({super.key,required this.transaction});
  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
  DepositController depositController = Get.find<DepositController>();
  SecurityController securityController = Get.find<SecurityController>();
  CreateGoalController createGoalController = Get.find<CreateGoalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffafafa),
        elevation: 0,
        iconTheme: IconThemeData(
          color: lightGrey, //change your color here
        ),
        title: const Text(""),
      ),
      body: fetchGoalsController.fetchSingleTransactionState == FetchSingleTransactionState.LOADING || fetchGoalsController.fetchSingleTransactionState == FetchSingleTransactionState.PENDING ?
          const Center(child: CircularProgressIndicator()) :
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListView(
              children: [
                fetchGoalsController.currentTransaction.type == TransactionType.DEPOSIT.name ?
                Text("+${formatter.format(fetchGoalsController.currentTransaction.amount)} FCFA", style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 30),) :
                Text("-${formatter.format(fetchGoalsController.currentTransaction.amount)} FCFA", style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 30),),
                Container(

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0,bottom: 20, left: 10,right: 10),
                    child: Column(
                      children: [

                        transaction.validators?.length != 0 ?
                        Container(
                          decoration:BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            //    Text("Validations: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: apCol),),
                                const Text("Pour que la transaction soit effective, l'approbation de ces membres est nécessaire. ",style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                                const SizedBox(height: 10,),
                                ValidatorsList(transaction: transaction)

                              ],
                            ),
                          ),
                        ) : const SizedBox(),
                        const SizedBox(height: 25,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Type",),
                            transaction.type == TransactionType.WITHDRAWAL.name ? const Text("RETRAIT") :
                            transaction.type == TransactionType.EMERGENCY_WITHDRAWAL.name ? const Text("RETRAIT D'URGENCE") :
                            transaction.type == TransactionType.DEPOSIT.name ? const Text("DÉPÔT") :
                            Text("${transaction.type}")
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Montant",),
                            Text("${formatter.format(transaction.amount)} FCFA"),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Frais",),
                            Text("${formatter.format(transaction.fee)} FCFA"),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Reférence",),
                            Flexible(child: SizedBox( child: Text(transaction.id ?? "",maxLines: 2,))),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Statut",),
                            fetchGoalsController.currentTransaction.status == ProcessingStatus.PENDING.name ? const Text("EN ATTENTE",style: TextStyle(color: Colors.orange)) :
                            fetchGoalsController.currentTransaction.status == ProcessingStatus.SUCCESS.name ? const Text("SUCCÉS",style: TextStyle(color: Colors.green)) :
                            fetchGoalsController.currentTransaction.status == ProcessingStatus.FAILED.name ? const Text("ECHEC",style: TextStyle(color: Colors.redAccent),) :
                            Text("${fetchGoalsController.currentTransaction.status}")
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Date",),
                            Text("${transaction.createdAt?.day.toString().padLeft(2, '0')}/${transaction.createdAt?.month.toString().padLeft(2, '0')}/${transaction.createdAt?.year} à ${transaction.createdAt?.hour.toString().padLeft(2, '0')}H ${transaction.createdAt?.minute.toString().padLeft(2, '0')}"),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Émetteur",),
                              Text(transaction.name ?? "Djizhub User"),

                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("téléphone",),
                            Text(transaction.phone_number.toString()),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Opérateur",),
                            Text(transaction.transactionOperator ?? ""),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Id transaction",),
                            transaction.partner_id == null ? const Text("") :
                            Text(transaction.partner_id.toString()),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Note : ",),
                            Text(transaction.note ?? "",),
                          ],
                        ),
                        transaction.validation_required ?? false ?
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(10.0),
                             child: ElevatedButton(
                               style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                               onPressed: () {
                               //  depositController.makeApprobation(context,transaction.id ?? "", UserApprobation.ACCEPT);
                                 _showApprobationChoiceDialog(context,transaction.id ?? "", UserApprobation.ACCEPT);
                               },
                               child: const Text("J'accecpte",style: TextStyle(color: Colors.white),),
                             ),

                           ),

                           Padding(
                             padding: const EdgeInsets.all(2.0),
                             child: ElevatedButton(
                               style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)),
                               onPressed: () {
                                 _showApprobationChoiceDialog(context,transaction.id ?? "",UserApprobation.DENIED);
                               },
                               child: const Text('Je refuse',style: TextStyle(color: Colors.white),),
                             ),

                           ),
                         ],
                       ) : const SizedBox(),
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
    );
  }
}

Future<void> _showApprobationChoiceDialog(BuildContext context,String transactionId,UserApprobation approbation) async {

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return GetBuilder<DepositController>(

          builder:(value)=> AlertDialog(
            title: const Text('Confirmation'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Êtes-vous certain(e) de vouloir confirmer votre choix ?'),
                ],
              ),
            ),
            actions: <Widget>[

             GetBuilder<DepositController>(builder: (value)=>value.makeAcceptApprobationState == MakeAcceptApprobationState.LOADING ?
                 const CircularProgressIndicator() :
              TextButton(
               child: const Text('Oui'),
               onPressed: () {

                 depositController.makeApprobation(context,transactionId, approbation);

               },
             )),

             GetBuilder<DepositController>(builder: (value)=> value.makeDeniedApprobationState == MakeDeniedApprobationState.LOADING ?
             const CircularProgressIndicator() :
             TextButton(
               child: const Text('Non',style: TextStyle(color: Colors.deepOrangeAccent),),
               onPressed: () {
                 Get.back();
               },
             )),
            ],
          ));
    },
  );
}
