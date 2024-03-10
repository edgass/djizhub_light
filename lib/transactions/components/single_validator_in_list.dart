import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/controllers/joinGoalController.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/models/member_list_model.dart';
import 'package:djizhub_light/transactions/components/transaction_list.dart';
import 'package:djizhub_light/transactions/controllers/fetch_member_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/goals_model.dart';
class SingleValidatorInList extends StatelessWidget {
  Validator validator;
  bool userIsAValidator;
  SingleValidatorInList({super.key,required this.validator,required this.userIsAValidator});
  var formatter = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: validator.name == "Moi" ? const Color(0XFFc4e5e9) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(validator.name ?? "",textAlign: TextAlign.left,style: const TextStyle(overflow: TextOverflow.ellipsis),),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(validator.status ?? "",style: TextStyle(overflow: TextOverflow.ellipsis),)),
                    Text(validator.phoneNumber ?? "")
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Future<void> _showDeletAccountDialogByAdmin(BuildContext context,Goal goal,String userId,String userName) async {

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return GetBuilder<JoinGoalController>(

          builder:(value)=> AlertDialog(
            title: const Text('Retrait du coffre'),
            content:  SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Êtes-vous certain de vouloir retirer $userName de ce coffre ?'),
                ],
              ),
            ),
            actions: <Widget>[
              value.disjoinGoalState == DisjoinGoalState.LOADING ? const SizedBox():
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              value.disjoinGoalState == DisjoinGoalState.LOADING ? const CircularProgressIndicator():
              TextButton(
                child: const Text('Retirer',style: TextStyle(color: Colors.deepOrangeAccent),),
                onPressed: () {
                  joinGoalController.disjoinGoalByAdmin(context, goal,userId);

                },
              ),
            ],
          ));
    },
  );
}