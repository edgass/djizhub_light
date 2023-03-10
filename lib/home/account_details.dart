import 'package:djizhub_light/home/info_box.dart';
import 'package:djizhub_light/home/single_transaction.dart';
import 'package:djizhub_light/home/transaction_actions.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
class AccoutDetails extends StatelessWidget {
  const AccoutDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
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
              ),
              SizedBox(height: 25,),
              Column(
                children: [
                  Text("Objectif voiture",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  SizedBox(height: 10,),
                  Text("Retrait : 12/05/2023",textAlign: TextAlign.center,style: TextStyle(),),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoBox(title: "Solde",price: 14000),
                      InfoBox(title: "Objectif",price: 25000),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(75),topRight: Radius.circular(65)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.1), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                      child: ListView(
                        children: [
                          Text("Transactions",textAlign: TextAlign.center,style: TextStyle(fontSize:20),),
                          SizedBox(height: 15,),
                          SingleTransactionInList(),
                          SingleTransactionInList(),
                          SingleTransactionInList(),
                          SingleTransactionInList(),
                          SingleTransactionInList(),
                          SingleTransactionInList(),
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
