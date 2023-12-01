import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class SingleTransactionDetails extends StatelessWidget {
  var formatter = NumberFormat("#,###");
   SingleTransactionDetails({super.key});
  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffafafa),
        elevation: 0,
        iconTheme: IconThemeData(
          color: lightGrey, //change your color here
        ),
        title: Text(""),
      ),
      body: GetBuilder<FetchGoalsController>(
        builder: (value)=> value.fetchSingleTransactionState == FetchSingleTransactionState.LOADING || value.fetchSingleTransactionState == FetchSingleTransactionState.PENDING ?
        Center(child: CircularProgressIndicator()) :
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListView(
            children: [
              Text("${formatter.format(value.currentTransaction.amount)} FCFA", style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30),),
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
                          Text("Type",),
                          Text(value.currentTransaction.type ?? ""),
                        ],
                      ),
                      SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Montant",),
                          Text("${formatter.format(value.currentTransaction.amount)} FCFA"),
                        ],
                      ),
                      SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Reférence",),
                          Flexible(child: SizedBox( child: Text(value.currentTransaction.id ?? "",maxLines: 2,))),
                        ],
                      ),
                      SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Statut",),
                          Text(value.currentTransaction.status ?? ""),
                        ],
                      ),
                      SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Date",),
                          Text("${value.currentTransaction.createdAt?.day}/${value.currentTransaction.createdAt?.month}/${value.currentTransaction.createdAt?.year} à ${value.currentTransaction.createdAt?.hour}H ${value.currentTransaction.createdAt?.minute}"),
                        ],
                      ),
                      SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Opérateur",),
                          Text(value.currentTransaction.transactionOperator ?? ""),
                        ],
                      ),
                      SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Id transaction",),
                          Text(""),
                        ],
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      )
    );
  }
}