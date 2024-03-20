import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/goals/controllers/joinGoalController.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/transactions/components/operator_card.dart';
import 'package:djizhub_light/transactions/controllers/deposit_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../globals.dart';
class Deposit extends StatefulWidget {
  String goalId;

   Deposit({super.key,required this.goalId});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final _depositFormKey = GlobalKey<FormState>();

  var formatter = NumberFormat("#,###");

  final storage = const FlutterSecureStorage();

 // TextEditingController nameController = TextEditingController(text: authController.userName ?? FirebaseAuth.instance.currentUser?.displayName);
  TextEditingController amountController = TextEditingController();

  TextEditingController otpController = TextEditingController();

  DepositController depositController = Get.find<DepositController>();

  JoinGoalController joinGoalController = Get.find<JoinGoalController>();

  AuthController authController = Get.find<AuthController>();

  RegExp myRegNumValidation = RegExp('0-9');

  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();

  TextEditingController numeroTelController = TextEditingController();

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

  void formatInput() {
    // Utilise NumberFormat pour formater le nombre avec une virgule
    NumberFormat formatter = NumberFormat('#,###');
    String formattedNumber = formatter.format(double.tryParse(amountController.text.replaceAll(',', '')));

    // Met à jour le texte dans le TextField avec le nombre formaté
    amountController.value = amountController.value.copyWith(
      text: formattedNumber,
      selection: TextSelection.collapsed(offset: formattedNumber.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dépot"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child:  SingleChildScrollView(
          child: Form(
            key: _depositFormKey,
            child: Column(
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OperatorCard(name:"Wave", assetPath: "assets/logo/wave_logo.png",operator: Operator.WAVE,),
                      OperatorCard(name:"Orange Money",assetPath: "assets/logo/om_logo.png",operator: Operator.OM),
                    ],
                  ),
                GetBuilder<DepositController>(
                    builder: (value)=> value.operator == Operator.OM  || value.operator == Operator.WAVE ? Padding(
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
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Ce champs est obligatoire';
                          }else if(val.length != 9 || (!val.startsWith('77') & !val.startsWith('78') & !val.startsWith('76') & !val.startsWith('75'))){
                            return 'Numéro de téléphone invalide';
                          }else if((val.startsWith('76') || (val.startsWith('75'))) && value.operator == Operator.OM ){
                            return 'Entrez un numéro OM valide';
                          }
                          return null;
                        },
                      ),
                    ) : const SizedBox(),),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    onChanged: (value){
                      formatInput();
                    },
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: "Montant",
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if(value!.isEmpty){
                        return 'Ce champs est obligatoire';
                      }else if (double.parse(value.replaceAll(',', '') ?? "0.0")<fetchGoalsController.currentGoal.value.min_transaction!) {
                        return 'Le montant minimum est de ${fetchGoalsController.currentGoal.value.min_transaction!} FCFA';
                      }else if (double.parse(value.replaceAll(',', '') ?? "0.0")>fetchGoalsController.currentGoal.value.max_transaction!) {
                        return 'Le montant maximum est de ${fetchGoalsController.currentGoal.value.max_transaction!} FCFA';
                      }
                      return null;
                    },
                  ),
                ),
                GetBuilder<DepositController>(
                  builder: (value)=> AnimatedSizeAndFade(
                    fadeDuration: const Duration(milliseconds: 300),
                    sizeDuration: const Duration(milliseconds: 600),
                    child: value.operator == Operator.OM ? Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: otpController,
                              decoration: const InputDecoration(
                                labelText: "Code de paiement",
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (textValue) {
                                if (textValue!.isEmpty && value.operator == Operator.OM ) {
                                  return 'Ce champs est obligatoire';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                            otpController.text = clipboardData?.text ?? "";

                          },
                          child: Icon(Icons.paste,color: lightGrey,),
                        )
                      ],
                    ) : const SizedBox(),
                  ),),
                GetBuilder<DepositController>(

                    builder: (value)=> value.operator == Operator.OM ?
                    AnimatedSizeAndFade(
                      fadeDuration: const Duration(milliseconds: 400),
                      child: RichText(
                          text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                    style: TextStyle(color: Colors.black54),
                                    text: "Pour obtenir un code de paiement, composez sur votre téléphone le #144#391# et suivez les instructions ou cliquez tout simplement"),
                                TextSpan(
                                  recognizer:TapGestureRecognizer()..onTap = (){

                                  },
                                  style: TextStyle(color: apCol,fontWeight: FontWeight.bold),
                                  text: " ici",


                                ),
                              ]
                          )
                      ),
                    ): const SizedBox(),),
                //Depot anonyme actuellement supprimé
                /*
                GetBuilder<JoinGoalController>(
                    builder: (value)=>CheckboxListTile(
                        title: Text("Faire un dépot anonyme (Cacher Nom et Numéro)"),
                        controlAffinity: ListTileControlAffinity.leading,

                        value: value.anonymousDeposit,
                        onChanged: (bool? value){
                          if(value != null){
                            joinGoalController.setAnonymousDeposit(value);
                          }
                        }

                    )),

                 */
                GetBuilder<DepositController>(
                    builder: (value)=> Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: value.makeTransactionState == MakeTransactionState.LOADING
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(apCol)),
                        onPressed: () {
                          print("221${numeroTelController.text}");
                          if(_depositFormKey.currentState!.validate()){
                            FocusScope.of(context).unfocus();
                            String amountCleanString = amountController.text.replaceAll(',', '');
                            String? finalName = "";
                            if(depositController.nameToSend == null){
                              if(authController.userName == null){
                                 finalName = FirebaseAuth.instance.currentUser?.displayName ?? "";
                              }else{
                                finalName = authController.userName!;
                              }
                            }else{
                              finalName = depositController.nameToSend!;
                            }
                            depositController.makeDeposit(context, newTransactionModel(joinGoalController.anonymousDeposit,"221${numeroTelController.text}", depositController.operator.name, double.parse(amountCleanString),otpController.text,null,null ), widget.goalId);
                          }

                        },
                        child: const Text('Envoyer',style: TextStyle(color: Colors.white),),
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