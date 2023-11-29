import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:djizhub_light/transactions/components/operator_card.dart';
import 'package:djizhub_light/transactions/controllers/deposit_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../globals.dart';
class Withdrawal extends StatelessWidget {
  String goalId;
   Withdrawal({super.key,required this.goalId});
  final _formKey = GlobalKey<FormState>();
  TextEditingController numeroTelController = TextEditingController();
  DepositController depositController = Get.find<DepositController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retrait"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child:  SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OperatorCard(name:"Wave", assetPath: "assets/logo/wave_logo.png",operator: Operator.WAVE,),
                    OperatorCard(name:"Orange Money",assetPath: "assets/logo/om_logo.png",operator: Operator.OM),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: numeroTelController,
                    decoration: InputDecoration(
                      prefix: Text("+221"),
                      labelText: "Numéro de Téléphone",
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ce champs est obligatoire';
                      }else if(value.length != 9 || (!value.startsWith('77') & !value.startsWith('78') & !value.startsWith('76') & !value.startsWith('75'))){
                        return 'Numéro de téléphone invalide';
                      }
                      return null;
                    },
                  ),
                ),
                GetBuilder<DepositController>(
                    builder: (value)=> Padding(
                      padding: EdgeInsets.all(20.0),
                      child: value.makeTransactionState == MakeTransactionState.LOADING
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(lightGrey)),
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            depositController.makeWithdrawal(context, newTransactionModel(numeroTelController.text, depositController.operator.name, null,null), goalId);
                          }

                        },
                        child: Text('Recevoir',style: TextStyle(color: Colors.white),),
                      ),
                    ))

              ],
            ),
          ),
        ),
      ),
    );
  }
}
