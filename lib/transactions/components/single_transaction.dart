import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/models/goals_model.dart';
import 'package:djizhub_light/transactions/components/single_transaction_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class SingleTransactionInList extends StatelessWidget {
  Transaction transaction;
   SingleTransactionInList({Key? key,required this.transaction}) : super(key: key);
   FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat("#,###");
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10) ,
        color: transaction.type == "WITHDRAWAL" ? Color(0xFFFFE4BD): transaction.type == "EMERGENCY_WITHDRAWAL" ? Color(0xFFFFCCCC) : null),
      child: InkWell(
        onTap: ()=>{
          fetchGoalsController.setCurrentTransaction(transaction),
          Get.to(()=>SingleTransactionDetails())
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0,left: 10,right: 10,bottom: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(transaction.transactionOperator ?? "",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
                        SizedBox(height: 4,),
                        Text("${transaction.createdAt?.day.toString().padLeft(2, '0')}/${transaction.createdAt?.month.toString().padLeft(2, '0')}/${transaction.createdAt?.year} à ${transaction.createdAt?.hour}h ${transaction.createdAt?.minute}",style: TextStyle(),),
                        SizedBox(height: 4,),
                        transaction.status == "PENDING" ?
                        Row(
                          children: [
                            Text("Statut : "),
                            Text("En attente",style: const TextStyle(color: Colors.orange),),
                          ],
                        ) :
                        transaction.status == "SUCCESS" ?
                        Row(
                          children: [
                            Text("Statut : "),
                            Text("Succés",style: const TextStyle(color: Colors.green),),
                          ],
                        ) :
                        Row(
                          children: [
                            Text("Statut : "),
                            Text("Echec",style: const TextStyle(color: Colors.redAccent),),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child:transaction.type == "DEPOSIT" ? Text("+${formatter.format(transaction.amount)} FCFA",textAlign:TextAlign.right,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),) :
                      Text("-${formatter.format(transaction.amount)} FCFA",textAlign:TextAlign.right,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)
                  )
                ],
              ),
              Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 3),
                    child: SizedBox(width:MediaQuery.of(context).size.width*0.4, child: Text(transaction.name ?? "Djizhub User",overflow: TextOverflow.ellipsis,)),
                  ),
                  Text(transaction.phone_number.toString())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
