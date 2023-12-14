import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:flutter/material.dart';
import 'package:djizhub_light/transactions/components/operator_card.dart';
import 'package:djizhub_light/transactions/controllers/deposit_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import 'package:intl/intl.dart';
class Withdrawal extends StatelessWidget {
  String goalId;
  bool emergency;
   Withdrawal({super.key,required this.goalId,required this.emergency});
  final _formKey = GlobalKey<FormState>();
  TextEditingController numeroTelController = TextEditingController();
  TextEditingController amountTelController = TextEditingController();
  DepositController depositController = Get.find<DepositController>();


  void formatInput() {
    // Utilise NumberFormat pour formater le nombre avec une virgule
    NumberFormat formatter = NumberFormat('#,###');
    String formattedNumber = formatter.format(double.parse(amountTelController.text.replaceAll(',', '')));

    // Met à jour le texte dans le TextField avec le nombre formaté
    amountTelController.value = amountTelController.value.copyWith(
      text: formattedNumber,
      selection: TextSelection.collapsed(offset: formattedNumber.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: emergency ? const Text("Retrait d'urgence") : Text("Retrait"),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    emergency ?
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        onChanged: (value){
                          formatInput();
                        },
                        keyboardType: TextInputType.number,
                        controller: amountTelController,
                        decoration: InputDecoration(
                          labelText: "Montant",
                        ),
                        validator: (value) {
                          if (value!.isEmpty & emergency) {
                            return 'Ce champs est obligatoire';
                          }
                          return null;
                        },
                      ),
                    ) : const SizedBox(),
                    emergency ?
                    Padding(
                      padding: EdgeInsets.only(top: 20.0,left: 10.0,right: 10.0),
                      child: Text("Lors d'un retrait d'urgence, la limite est de 50 % du compte, soit ${((int.parse(fetchGoalsController.currentGoal.value.balance.toString())~/2) /5).floor() * 5} FCFA maximum, avec une pénalité de 5 % sur le montant retiré.",textAlign: TextAlign.center,style: TextStyle(color: Colors.redAccent),),
                    ) : SizedBox(),
                    emergency ?
                    GetBuilder<DepositController>(
                        builder: (value)=>CheckboxListTile(
                            title: Text("J'accepte"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: value.acceptEmmergencyTerm,
                            onChanged: (bool? value){
                              if(value != null){
                                depositController.setAcceptEmmergencyTerm(value);
                              }
                            }
        
                        )) : SizedBox(),
                    GetBuilder<DepositController>(
                        builder: (value)=> Padding(
                          padding: EdgeInsets.all(20.0),
                          child: value.makeTransactionState == MakeTransactionState.LOADING
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(emergency & !depositController.acceptEmmergencyTerm ? Colors.black12 : lightGrey)),
                         onPressed:emergency ?
                                             emergency & !depositController.acceptEmmergencyTerm ? null : () {
                                               if(_formKey.currentState!.validate()){
                                                 depositController.makeWithdrawal(context, newTransactionModel(
                                                     "221${numeroTelController.text}", depositController.operator.name, double.parse(amountTelController.text.replaceAll(',', '')),null,emergency), goalId);
                                               }

                                             } :
                             () {
                           if(_formKey.currentState!.validate()){
                             depositController.makeWithdrawal(context, newTransactionModel(
                                 "221${numeroTelController.text}", depositController.operator.name, null,null,emergency), goalId);
                           }

                         },
                         onLongPress: null,
        
                            child: Text('Recevoir',style: TextStyle(color: Colors.white),),
                          ),
                        ))
        
                  ],
                ),
              ),

          ),
        ),
      ),
    );
  }
}
