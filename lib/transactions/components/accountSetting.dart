import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import '../../models/goals_model.dart';
class AccountParameter extends StatelessWidget {
  Goal goal;
  AccountParameter({super.key,required this.goal});
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController descriptionController = TextEditingController()..text = fetchGoalsController.currentGoal.value.description ?? "";
  TextEditingController nameController = TextEditingController()..text = fetchGoalsController.currentGoal.value.name!;
  TextEditingController objectifController = TextEditingController()..text = fetchGoalsController.currentGoal.value.goal.toString();


  @override
  Widget build(BuildContext context) {
    CreateGoalController createGoalController = Get.find<CreateGoalController>();
    return  Scaffold(
      appBar: AppBar(
        title: Text("Paramétres du coffre"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  SizedBox(height: 20,),
                  Text("Identifiant : ${fetchGoalsController.currentGoal.value.code}",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("N'échangez ce code qu'avec ceux avec qui vous souhaitez partager les informations du coffre. Cependant, les personnes à qui vous le partagez ne pourront faire que des dépôts, pas de retraits.",textAlign:TextAlign.center, style: TextStyle(fontSize: 10),),
                  SizedBox(height: 20,),
                  TextFormField(
                    maxLength: 12,
                    controller: nameController,
                    decoration: InputDecoration(
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
                    decoration: InputDecoration(

                      labelText: "Description",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0,bottom: 10),
                    child: TextFormField(
                      controller: objectifController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        suffix: Text("FCFA"),
                        labelText: "Objectif",
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (int.parse(value ?? "0") <5000) {
                          return 'Le montant minimum est de 5000 FCFA';
                        }else if(int.parse(value ?? "0") > 10000000){
                          return 'Le montant maximum est de 10.000.000 FCFA';
                        }else if(int.parse(value ?? "0") < int.parse(fetchGoalsController.currentGoal.value.goal.toString())){
                          return 'Minimum déja fixé : ${fetchGoalsController.currentGoal.value.goal} FCFA';
                        }
                        return null;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>createGoalController.selectUpdateDate(context),
                    child: AbsorbPointer(
                      child:

                      Padding(
                          padding: EdgeInsets.only(top: 25.0,bottom: 10),

                          child: GetBuilder<CreateGoalController>(
                            builder:(value)=>  TextFormField(
                              controller: TextEditingController(text: "${value.selectedUpdateDate.toLocal()}".split(' ')[0]),
                              decoration: const InputDecoration(
                                labelText: "ÉCHÉANCE",
                              ),
                              // The validator receives the text that the user has entered.
                            ),
                          )


                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0,bottom: 10),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        GetBuilder<CreateGoalController>(
                            builder: (value)=>CheckboxListTile(
                                title: Text("Contrainte d'objectif"),
                                controlAffinity: ListTileControlAffinity.leading,

                                value: value.goalConstraintOfUpdate,
                                onChanged: fetchGoalsController.currentGoal.value.constraint ?? true ? null : (value){
                                  createGoalController.setUpdateGoalConstraint(value!);
                                }

                            )),
                        fetchGoalsController.currentGoal.value.constraint ?? true ?
                        Text("Vous avez déjà validé la contrainte d'objectif. Vous récupérerez vos fonds dès que l'échéance sera atteinte et que vous aurez accompli votre objectif financier.") :
                        Text("Lorsque vous cochez cette case, vous ne pourrez pas retirer vos fonds tant que vous n'aurez pas atteint votre objectif financier, même si la date de retrait est déjà arrivée")
                      ],

                    ),

                  ),
                  Padding(
                      padding: EdgeInsets.all(20.0),
                      child: GetBuilder<CreateGoalController>(
                        builder: (value)=> value.updateGoalState == UpdateGoalState.LOADING
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(apCol)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()){
                              createGoalController.updateGoal(context, newGoalModel(fetchGoalsController.currentGoal.value.id,nameController.text, descriptionController.text, double.parse(objectifController.text), createGoalController.selectedUpdateDate.toString(), createGoalController.goalConstraintOfUpdate));
                            }
                          },
                          child: Text('Modifier',style: TextStyle(color: Colors.white),),
                        ),
                      )
                  )
                ]))),
      ),
    );
  }
}
