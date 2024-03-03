
import 'package:djizhub_light/goals/components/account_filtered_section.dart';
import 'package:djizhub_light/goals/components/goals_loading_shimmer.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AccountList extends StatelessWidget {
   AccountList({Key? key}) : super(key: key);
  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();


  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Obx(
        ()=> fetchGoalsController.fetchState.value == FetchState.LOADING ?
        const GoalsLoadingShimmer() :
        fetchGoalsController.fetchState.value == FetchState.SUCCESS && fetchGoalsController.goals.value.isEmpty  ?

                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Pour commencer à épargner et à participer à des tontines, créez vos coffres d'épargne et rejoignez des groupes de tontine dès maintenant.",textAlign: TextAlign.center,),
                ):
        fetchGoalsController.fetchState.value == FetchState.SUCCESS && fetchGoalsController.goals.value.isNotEmpty  ?
                AccountFilteredSection() :


            const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text("Une erreur s'est produite. Veuillez actualiser la page ou vérifier votre connexion internet.",textAlign: TextAlign.center,),
        ),
      )
    );
  }
}
