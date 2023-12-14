import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/components/goals_loading_shimmer.dart';
import 'package:djizhub_light/goals/components/single_account_in_list.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';

import '../../models/goals_model.dart';
class AccountFilteredSection extends StatefulWidget {
   AccountFilteredSection({super.key});

  @override
  State<AccountFilteredSection> createState() => _AccountFilteredSectionState();
}



class _AccountFilteredSectionState extends State<AccountFilteredSection> {
  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
   List<Goal> containWithDraw = [];
   List<Goal> containOPENED = [];
  @override
  void initState() {
     containWithDraw = fetchGoalsController.goals.value.where((goal) => goal.status == "WITHDRAWN").toList();
     containOPENED = fetchGoalsController.goals.value.where((goal) => goal.status != "WITHDRAWN").toList();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(

      children: [
        FlutterToggleTab
          (
          width: 40,
          height: 35,
          borderRadius: 15,
          selectedTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w600),
          unSelectedTextStyle: TextStyle(
              color: lightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w400),
          labels: const ["En cours","Clôturés"],
          //  icons: _listIconTabToggle,
          selectedIndex: fetchGoalsController.selectedTab.value,
          selectedLabelIndex: (index) {
            fetchGoalsController.selectedTab(index);
          },
        ),

        fetchGoalsController.selectedTab.value == 0 && fetchGoalsController.openedGoals.isEmpty ?
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Pour le moment, vous n'avez aucun compte actif. Créez un compte !",textAlign: TextAlign.center,),
        ) :
        fetchGoalsController.selectedTab.value == 1 && fetchGoalsController.closedGoals.isEmpty ?
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Pour le moment, vous n'avez aucun compte cloturé.",textAlign: TextAlign.center,),
        ) :
        fetchGoalsController.selectedTab.value == 0 && fetchGoalsController.openedGoals.isNotEmpty ?
        Padding(
          padding: const EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Column(
            children: [
              for(var goal in fetchGoalsController.openedGoals ?? [])
                SingleAccountInList(currentGoal: goal),
            ],
          ),
        ) :
        fetchGoalsController.selectedTab.value == 1 && fetchGoalsController.closedGoals.isNotEmpty ?
        Padding(
          padding: const EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Column(
            children: [
              for(var goal in fetchGoalsController.closedGoals ?? [])
                SingleAccountInList(currentGoal: goal),
            ],
          ),
        )   : SizedBox()



      ],
    ),

    );
  }
}
