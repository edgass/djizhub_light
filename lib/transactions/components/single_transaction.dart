import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/models/goals_model.dart';
import 'package:djizhub_light/transactions/components/single_transaction_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class SingleTransactionInList extends StatelessWidget {
  Transaction transaction;
   SingleTransactionInList({Key? key,required this.transaction}) : super(key: key);
   FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat("#,###");
    return Stack(

      children: [
        Container(

          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10) ,
            color: transaction.type == "WITHDRAWAL" ? const Color(0xFFFFE4BD): transaction.type == "EMERGENCY_WITHDRAWAL" ? const Color(0xFFFFCCCC) : Colors.white),
          child: InkWell(
            onTap: ()=>{
              fetchGoalsController.setCurrentTransaction(transaction),
              Get.to(()=>SingleTransactionDetails(transaction: transaction,))
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transaction.transactionOperator ?? "",style: const TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
                          const SizedBox(height: 4,),
                          Text("${transaction.createdAt?.day.toString().padLeft(2, '0')}/${transaction.createdAt?.month.toString().padLeft(2, '0')}/${transaction.createdAt?.year} à ${transaction.createdAt?.hour}h ${transaction.createdAt?.minute}",style: const TextStyle(),),
                          const SizedBox(height: 4,),
                          transaction.status == "PENDING" ?
                          const Row(
                            children: [
                              Text("Statut : "),
                              Text("En attente",style: TextStyle(color: Colors.orange),),
                            ],
                          ) :
                          transaction.status == "SUCCESS" ?
                          const Row(
                            children: [
                              Text("Statut : "),
                              Text("Succés",style: TextStyle(color: Colors.green),),
                            ],
                          ) :
                          const Row(
                            children: [
                              Text("Statut : "),
                              Text("Echec",style: TextStyle(color: Colors.redAccent),),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                          child:transaction.type == "DEPOSIT" ? Text("+${formatter.format(transaction.amount)} FCFA",textAlign:TextAlign.right,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),) :
                          Text("-${formatter.format(transaction.amount)} FCFA",textAlign:TextAlign.right,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width:MediaQuery.of(context).size.width*0.4, child: Text(transaction.name ?? "Djizhub User",overflow: TextOverflow.ellipsis,)),
                      Text(transaction.phone_number.toString())
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        transaction.validation_required ?? false ?
        Positioned(
          top: -10,
          left: -10,
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(0.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.info_outlined,color: Colors.white,),
              ),
            ),
          ),
        ).animate(
          // this delay only happens once at the very start
          onPlay: (controller) => controller.repeat(reverse: true), // loop
        ).scale(duration: 3000.ms,curve: Curves.easeInOut ).addEffect(ShimmerEffect()) : SizedBox(),
      ],
    );
  }
}
