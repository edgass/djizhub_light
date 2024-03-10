import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import '../../models/goals_model.dart';
import 'package:intl/intl.dart';
class AccountParameter extends StatelessWidget {
  Goal goal;
  AccountParameter({super.key,required this.goal});
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController descriptionController = TextEditingController()..text = fetchGoalsController.currentGoal.value.description ?? "";
  TextEditingController nameController = TextEditingController()..text = fetchGoalsController.currentGoal.value.name!;
  TextEditingController nbrParticipantsController = TextEditingController()..text = fetchGoalsController.currentGoal.value.limit_guest.toString();
  TextEditingController objectifController = TextEditingController()..text = fetchGoalsController.currentGoal.value.goal.toString();
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
        title: const Text("Paramétres du coffre"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  const SizedBox(height: 20,),
                  Text("Identifiant : ${fetchGoalsController.currentGoal.value.code}",style: const TextStyle(fontWeight: FontWeight.bold),),
                  const Text("N'échangez ce code qu'avec ceux avec qui vous souhaitez partager les informations du coffre. Cependant, les personnes à qui vous le partagez ne pourront faire que des dépôts, pas de retraits.",textAlign:TextAlign.center, style: TextStyle(fontSize: 10),),
                  const SizedBox(height: 20,),
                  TextFormField(
                    maxLength: 12,
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nom",
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
                    decoration: const InputDecoration(

                      labelText: "Description",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                    child: TextFormField(
                      onChanged: (value){
                        formatInput();
                      },
                      controller: objectifController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        suffix: Text("FCFA"),
                        labelText: "Objectif",
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (int.parse(value?.replaceAll(',', '') ?? "0") <5000) {
                          return 'Le montant minimum est de 5000 FCFA';
                        }if(int.parse(value?.replaceAll(',', '') ?? "0") > 10000000){
                          return 'Le montant maximum est de 10.000.000 FCFA';
                        }else if(int.parse(value?.replaceAll(',', '') ?? "0") < int.parse(fetchGoalsController.currentGoal.value.goal.toString())){
                          return 'Minimum déja fixé : ${fetchGoalsController.currentGoal.value.goal} FCFA';
                        }
                        return null;
                      },
                    ),
                  ),
                  GetBuilder<FetchGoalsController>(
                    builder: (value)=> value.currentGoal.value.type == GoalType.TONTIN.name ? TextFormField(
                      controller: nbrParticipantsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        helperText: 'Veuillez indiquer le nombre total de participants prévu pour cette tontine.',
                        labelText: "Nombre de participants",
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
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
                  fetchGoalsController.currentGoal.value.type == GoalType.PRIVATE.name ?
                  GestureDetector(
                    onTap: ()=>createGoalController.selectUpdateDate(context),
                    child: AbsorbPointer(
                      child:

                      Padding(
                          padding: const EdgeInsets.only(top: 25.0,bottom: 10),

                          child: GetBuilder<CreateGoalController>(
                            builder:(value)=>  TextFormField(
                              controller: TextEditingController(text: "${value.selectedUpdateDate.day.toString().padLeft(2, '0')} ${DateFormat.MMMM('fr').format(value.selectedUpdateDate)} ${value.selectedUpdateDate.year}"),
                              decoration: const InputDecoration(
                                labelText: "ÉCHÉANCE",
                              ),
                              // The validator receives the text that the user has entered.
                            ),
                          )


                      ),
                    ),
                  ) : const SizedBox(),
                  fetchGoalsController.currentGoal.value.type == GoalType.PRIVATE.name ?
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        GetBuilder<CreateGoalController>(
                            builder: (value)=>CheckboxListTile(
                                title: const Text("Contrainte d'objectif"),
                                controlAffinity: ListTileControlAffinity.leading,

                                value: value.goalConstraintOfUpdate,
                                onChanged: fetchGoalsController.currentGoal.value.constraint ?? true ? null : (value){
                                  createGoalController.setUpdateGoalConstraint(value!);
                                }

                            )),
                        fetchGoalsController.currentGoal.value.constraint ?? true ?
                        const Text("Vous avez déjà validé la contrainte d'objectif. Vous récupérerez vos fonds dès que l'échéance sera atteinte et que vous aurez accompli votre objectif financier.") :
                        const Text("Lorsque vous cochez cette case, vous ne pourrez pas retirer vos fonds tant que vous n'aurez pas atteint votre objectif financier, même si la date de retrait est déjà arrivée")
                      ],

                    ),

                  ) : const SizedBox(),
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GetBuilder<CreateGoalController>(
                        builder: (value)=> value.updateGoalState == UpdateGoalState.LOADING
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(apCol)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()){
                              createGoalController.updateGoal(context, newGoalModel(fetchGoalsController.currentGoal.value.id,nameController.text, descriptionController.text, double.parse(objectifController.text), createGoalController.selectedUpdateDate.toString(), createGoalController.goalConstraintOfUpdate,null,int.parse(nbrParticipantsController.text)));
                            }
                          },
                          child: const Text('Modifier',style: TextStyle(color: Colors.white),),
                        ),
                      )
                  )
                ]))),
      ),
    );
  }
}
