
import 'package:djizhub_light/goals/components/account_filtered_section.dart';
import 'package:djizhub_light/goals/components/goals_loading_shimmer.dart';
import 'package:djizhub_light/goals/components/single_account_in_list.dart';
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
        GoalsLoadingShimmer() :
        fetchGoalsController.fetchState.value == FetchState.SUCCESS && fetchGoalsController.goals.value.isEmpty  ?

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Bienvenue, vous n'avez encore rien épargné. Créez un compte et profitez de notre solution.",textAlign: TextAlign.center,),
                ):
        fetchGoalsController.fetchState.value == FetchState.SUCCESS && fetchGoalsController.goals.value.isNotEmpty  ?
                AccountFilteredSection() :


            Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text("Une Erreur est survenue, veillez rafraichir la page ou verifiez votre connexion.",textAlign: TextAlign.center,),
        ),
      )
    );
  }
}
