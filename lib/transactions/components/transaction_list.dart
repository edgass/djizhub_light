
import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/transactions/components/single_transaction.dart';
import 'package:flutter/material.dart';

import '../../models/goals_model.dart';
import '../../models/member_list_model.dart';
class TransactionList extends StatelessWidget {
  SingleMember member;
   TransactionList(this.member,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des transactions'),
      ),
      /*
      body:     Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("${member.name}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: apCol),),
              ),
              member.transactions!.isEmpty ?
                  Text("Ce participant n'a pas encore éffectué de transaction") :
                  Column(
                    children: [
                      for(Transaction transaction in member.transactions ?? [])
                        SingleTransactionInList(transaction: transaction),
                    ],
                  )
          
            ],
          ),
        ),
      ),
    );

       */
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "${member.name}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: apCol,
              ),
            ),
          ),
          Expanded(
            child: member.transactions!.isEmpty
                ? Center(
              child: Text(
                "Ce participant n'a pas encore effectué de transaction",
              ),
            )
                : Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ListView.separated(
                                itemCount: member.transactions!.length,
                                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 10.0,),
                                itemBuilder: (BuildContext context, int index) {
                  Transaction transaction = member.transactions![index];
                  return SingleTransactionInList(
                    transaction: transaction,
                  );
                                },
                              ),
                ),
          ),
        ],
      ),
    );
  }
}
