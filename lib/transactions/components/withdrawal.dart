import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:djizhub_light/transactions/components/operator_card.dart';
import 'package:djizhub_light/transactions/controllers/deposit_controller.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import 'package:intl/intl.dart';
class Withdrawal extends StatefulWidget {
  String goalId;
  bool emergency;
   Withdrawal({super.key,required this.goalId,required this.emergency});

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController numeroTelController = TextEditingController();

  TextEditingController amountTelController = TextEditingController();

  TextEditingController noteController = TextEditingController();

  DepositController depositController = Get.find<DepositController>();

  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();

  AuthController authController = Get.find<AuthController>();

  void formatInput() {
    // Utilise NumberFormat pour formater le nombre avec une virgule
    NumberFormat formatter = NumberFormat('#,###');
    String formattedNumber = formatter.format(double.tryParse(amountTelController.text.replaceAll(',', '')));

    // Met à jour le texte dans le TextField avec le nombre formaté
    amountTelController.value = amountTelController.value.copyWith(
      text: formattedNumber,
      selection: TextSelection.collapsed(offset: formattedNumber.length),
    );
  }

  @override
  void initState() {
    super.initState();
    numeroTelController = TextEditingController(text: fetchGoalsController.numbers.isNotEmpty ? fetchGoalsController.numbers[0].replaceFirst("221", "") : '');
  }

  void setNumber(String number) {
    setState(() {
      numeroTelController.text = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.emergency ? const Text("Retrait d'urgence") : const Text("Retrait"),
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
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: numeroTelController,
                        decoration: InputDecoration(
                          prefix: Text("+221"),
                          suffixIcon: fetchGoalsController.numbers.isNotEmpty ? InkWell(
                            child: Icon(Icons.arrow_forward_ios,color: apCol,size: 17,),
                            onTap: ()=> _showNumberListDialog(context,setNumber),
                          ) : null,
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
                    widget.emergency ?
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        onChanged: (value){
                          formatInput();
                        },
                        keyboardType: TextInputType.number,
                        controller: amountTelController,
                        decoration: const InputDecoration(
                          labelText: "Montant",
                        ),
                        validator: (value) {
                          if (value!.isEmpty & widget.emergency) {
                            return 'Ce champs est obligatoire';
                          }
                          return null;
                        },
                      ),
                    ) : const SizedBox(),
                    widget.emergency ?
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                      child: Text("Lors d'un retrait d'urgence, la limite est de 50 % du compte, soit ${((int.parse(fetchGoalsController.currentGoal.value.balance.toString())~/2) /5).floor() * 5} FCFA maximum, avec une pénalité de 5 % sur le montant retiré.",textAlign: TextAlign.center,style: const TextStyle(color: Colors.redAccent),),
                    ) : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        maxLength: 100,
                        maxLines: 2,
                        controller: noteController,
                        decoration: const InputDecoration(

                          labelText: "Description",
                        ),
                      ),
                    ),
                    !widget.emergency ?
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0,left: 10.0,right: 10.0),
                      child: Text("Les retraits sont soumis à des frais de 2%.",textAlign: TextAlign.center,),
                    ) : const SizedBox(),
                    widget.emergency ?
                    GetBuilder<DepositController>(
                        builder: (value)=>CheckboxListTile(
                            title: const Text("J'accepte"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: value.acceptEmmergencyTerm,
                            onChanged: (bool? value){
                              if(value != null){
                                depositController.setAcceptEmmergencyTerm(value);
                              }
                            }

                        )) : const SizedBox(),
                    GetBuilder<DepositController>(
                        builder: (value)=> Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: value.makeTransactionState == MakeTransactionState.LOADING
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(widget.emergency & !depositController.acceptEmmergencyTerm ? Colors.black12 : lightGrey)),
                         onPressed:widget.emergency ?
                                             widget.emergency & !depositController.acceptEmmergencyTerm ? null : () {
                                               if(_formKey.currentState!.validate()){
                                                 depositController.makeWithdrawal(context, newTransactionModel(
                                                     null,"221${numeroTelController.text}", depositController.operator.name, double.parse(amountTelController.text.replaceAll(',', '')),null,widget.emergency,noteController.text), widget.goalId);
                                               }

                                             } :
                             () {
                           if(_formKey.currentState!.validate()){
                               if(authController.userName == null){
                               }else{
                               }

                             depositController.makeWithdrawal(context, newTransactionModel(
                                 null,"221${numeroTelController.text}", depositController.operator.name, null,null,widget.emergency,noteController.text), widget.goalId);
                           }

                         },
                         onLongPress: null,

                            child: const Text('Recevoir',style: TextStyle(color: Colors.white),),
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

Future<void> _showNumberListDialog(BuildContext context,Function(String) setNumber) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return GetBuilder<FetchGoalsController>(
        builder: (value)=>AlertDialog(
          title: const Text('Choisir un numéro'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                for(String num in fetchGoalsController.numbers)
                  InkWell(
                    onTap: (){
                      setNumber(num.replaceFirst("221", ""));
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(fetchGoalsController.transformNumberWithSpace(num.replaceFirst("221", "")),style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ),
                  )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )

          ],
        ),
      );
    },
  );
}