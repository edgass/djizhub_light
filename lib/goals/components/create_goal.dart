import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import 'package:intl/intl.dart';

class CreateGoal extends StatelessWidget {
   CreateGoal({super.key});
  final _formKey = GlobalKey<FormState>();
   bool isLoading = false;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController nbrParticipantsController = TextEditingController();
  TextEditingController objectifController = TextEditingController();
   var formatter = NumberFormat("#,###");


  @override
  Widget build(BuildContext context) {
    CreateGoalController createGoalController = Get.find<CreateGoalController>();


    void formatInput() {
      // Utilise NumberFormat pour formater le nombre avec une virgule
      NumberFormat formatter = NumberFormat('#,###');
      String formattedNumber = formatter.format(double.parse(objectifController.text.replaceAll(',', '')));

      // Met à jour le texte dans le TextField avec le nombre formaté
      objectifController.value = objectifController.value.copyWith(
        text: formattedNumber,
        selection: TextSelection.collapsed(offset: formattedNumber.length),
      );
    }
    return  Scaffold(
      appBar: AppBar(
        title: Text("Créer un coffre"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  TextFormField(
                    maxLength: 12,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Quel nom voudrais-tu donner à ce coffre ?",
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ce champs est obligatoire';
                      }
                      if(value.length < 5){
                        return 'Nom trop court';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    maxLength: 100,
                    maxLines: 2,
                    controller: descriptionController,
                    decoration: InputDecoration(

                      labelText: "Description",
                    ),
                  ),
                 GetBuilder<CreateGoalController>(

                   builder: (value)=> Padding(
                   padding: EdgeInsets.only(top: 10.0,bottom: 10),
                   child: TextFormField(
                     onChanged: (value){
                       formatInput();
                     },
                     controller: objectifController,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(

                       suffix: Text("FCFA"),
                       labelText: value.goalType == GoalType.PRIVATE ? "Objectif financier pour ce coffre" : "Montant retrait (Teggi Natt)",
                     ),
                     // The validator receives the text that the user has entered.
                     validator: value.goalType == GoalType.PRIVATE ? (value) {
                       if (int.parse(value?.replaceAll(',', '') ?? "0") <5000) {
                         return 'Le montant minimum est de 5000 FCFA';
                       }else if(int.parse(value?.replaceAll(',', '') ?? "0") > 10000000){
                         return 'Le montant maximum est de 10.000.000 FCFA';
                       }
                       return null;
                     } : null,
                   ),
                 ),),

                  GetBuilder<CreateGoalController>(
                      builder: (value)=> value.goalType == GoalType.TONTIN ? TextFormField(
                        controller: nbrParticipantsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          helperText: 'Veuillez indiquer le nombre total de participants prévu pour cette tontine.',
                          labelText: "Nombre de participants",
                        ),
                        // The validator receives the text that the user has entered.
                        validator:value.goalType == GoalType.PRIVATE ? null : (value) {
                          if (value!.isEmpty) {
                            return 'Ce champs est obligatoire';
                          }
                          if(int.parse(value) < 2){
                            return 'Il faut au moins deux personnes dans le groupe';
                          }
                          return null;
                        },
                      ) : const SizedBox(),
                  ),
                  GestureDetector(
                    onTap: ()=>createGoalController.selectDate(context),
                    child: AbsorbPointer(
                      child:GetBuilder<CreateGoalController>(builder: (value)=> value.goalType == GoalType.PRIVATE ? Padding(
                          padding: EdgeInsets.only(top: 25.0,bottom: 10),

                          child: GetBuilder<CreateGoalController>(
                            builder:(value)=>  TextFormField(
                              controller: TextEditingController(text: "${value.selectedDate.toLocal()}".split(' ')[0]),
                              decoration: const InputDecoration(
                                labelText: "ÉCHÉANCE",
                              ),
                              // The validator receives the text that the user has entered.
                            ),
                          )


                      ) : SizedBox()),
                    ),
                  ),
                GetBuilder<CreateGoalController>(
                    builder: (value)=>Padding(
                  padding: EdgeInsets.only(top: 10.0,bottom: 10),
                  child: value.goalType == GoalType.PRIVATE ?  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      CheckboxListTile(
                        title: Text("Contrainte d'objectif"),
                         controlAffinity: ListTileControlAffinity.leading,

                        value: value.goalConstraint,
                        onChanged: (bool? value){
                            if(value != null){
                              createGoalController.setGoalConstraint(value);
                            }
                        }

                        ),
                      Text("Lorsque vous cochez cette case, vous ne pourrez pas retirer vos fonds tant que vous n'aurez pas atteint votre objectif financier, même si la date de retrait est déjà arrivée")
                    ],
                    
                  ) : null,

                  )),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: GetBuilder<CreateGoalController>(
                      builder: (value)=> value.createGoalState == CreateGoalState.LOADING
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(apCol)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()){
                            String objectifCleanString = objectifController.text.replaceAll(',', '');
                            createGoalController.createNewGoal(context, newGoalModel(null,nameController.text, descriptionController.text, double.parse(objectifCleanString), createGoalController.selectedDate.toString(), createGoalController.goalConstraint,createGoalController.goalType,int.tryParse(nbrParticipantsController.text) ?? 0));
                          }
                        },
                        child: Text('Envoyer',style: TextStyle(color: Colors.white),),
                      ),
                    )
                  )
                ]))),
      ),
    );
  }
}
