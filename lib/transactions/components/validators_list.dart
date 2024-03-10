import 'package:djizhub_light/models/goals_model.dart';
import 'package:djizhub_light/transactions/controllers/deposit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ValidatorsList extends StatelessWidget {
  Transaction transaction;
   ValidatorsList({super.key,required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(Validator validator in transaction.validators ?? [])
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${validator.name}"),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${validator.phoneNumber}"),
                            validator.status == ProcessingStatus.ACCEPT.name ? const Text("APPROUVÉ",style: TextStyle(color: Colors.green),) :
                            validator.status == ProcessingStatus.PENDING.name ? const Text("NEUTRE",style: TextStyle(color: Colors.orange),) :
                            validator.status == ProcessingStatus.DENIED.name ? const Text("REFUSÉ",style: TextStyle(color: Colors.redAccent),) :
                            Text("${validator.status}")
                          ],
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    ) ;


  }
}
