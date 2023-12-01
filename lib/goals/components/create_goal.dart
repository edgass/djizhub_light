import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';
class CreateGoal extends StatelessWidget {
   CreateGoal({super.key});
  final _formKey = GlobalKey<FormState>();
   bool isLoading = false;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController objectifController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    CreateGoalController createGoalController = Get.find<CreateGoalController>();
    return  Scaffold(
      appBar: AppBar(
        title: Text("Créer une épargne"),
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
                        if (int.parse(value ?? "0") <500) {
                          return 'Le montant minimum est de 500 FCFA';
                        }
                        return null;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>createGoalController.selectDate(context),
                    child: AbsorbPointer(
                      child:

                      Padding(
                        padding: EdgeInsets.only(top: 25.0,bottom: 10),

                        child: GetBuilder<CreateGoalController>(
                          builder:(value)=>  TextFormField(
                            controller: TextEditingController(text: "${value.selectedDate.toLocal()}".split(' ')[0]),
                            decoration: const InputDecoration(
                              labelText: "Date de retrait",
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

                        value: value.goalConstraint,
                        onChanged: (bool? value){
                            if(value != null){
                              createGoalController.setGoalConstraint(value);
                            }
                        }

                        )),
                      Text("Lorsque vous cochez cette case, vous ne pourrez pas retirer vos fonds tant que vous n'aurez pas atteint votre objectif, même si la date de retrait est déjà arrivée")
                    ],
                    
                  ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: GetBuilder<CreateGoalController>(
                      builder: (value)=> value.createGoalState == CreateGoalState.LOADING
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(apCol)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()){
                            createGoalController.createNewGoal(context, newGoalModel(nameController.text, descriptionController.text, double.parse(objectifController.text), createGoalController.selectedDate.toString(), createGoalController.goalConstraint));
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
