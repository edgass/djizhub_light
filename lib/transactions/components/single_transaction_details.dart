import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/utils/security/security_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/deposit_controller.dart';
class SingleTransactionDetails extends StatelessWidget {
  var formatter = NumberFormat("#,###");
   SingleTransactionDetails({super.key});
  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
  DepositController depositController = Get.find<DepositController>();
  SecurityController securityController = Get.find<SecurityController>();

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
      body: GetBuilder<FetchGoalsController>(
          builder: (value)=> value.fetchSingleTransactionState == FetchSingleTransactionState.LOADING || value.fetchSingleTransactionState == FetchSingleTransactionState.PENDING ?
          const Center(child: CircularProgressIndicator()) :
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListView(
              children: [
                Text("${formatter.format(value.currentTransaction.amount)} FCFA", style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 30),),
                Container(

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0,bottom: 20, left: 10,right: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Type",),
                            Text(value.currentTransaction.type ?? ""),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Montant",),
                            Text("${formatter.format(value.currentTransaction.amount)} FCFA"),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Frais",),
                            Text("${formatter.format(value.currentTransaction.fee)} FCFA"),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Reférence",),
                            Flexible(child: SizedBox( child: Text(value.currentTransaction.id ?? "",maxLines: 2,))),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Statut",),
                            Text(value.currentTransaction.status ?? ""),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Date",),
                            Text("${value.currentTransaction.createdAt?.day.toString().padLeft(2, '0')}/${value.currentTransaction.createdAt?.month.toString().padLeft(2, '0')}/${value.currentTransaction.createdAt?.year} à ${value.currentTransaction.createdAt?.hour.toString().padLeft(2, '0')}H ${value.currentTransaction.createdAt?.minute.toString().padLeft(2, '0')}"),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Émetteur",),
                              Text(value.currentTransaction.name ?? "Djizhub User"),

                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("téléphone",),
                            Text(value.currentTransaction.phone_number.toString()),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Opérateur",),
                            Text(value.currentTransaction.transactionOperator ?? ""),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Id transaction",),
                            value.currentTransaction.partner_id == null ? const Text("") :
                            Text(value.currentTransaction.partner_id.toString()),
                          ],
                        ),
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Note : ",),
                            Text(value.currentTransaction.note ?? "",),
                          ],
                        ),
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
    );
  }
}
