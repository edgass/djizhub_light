import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/components/single_member_in_list.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/models/member_list_model.dart';
import 'package:djizhub_light/transactions/controllers/fetch_member_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MemberList extends StatelessWidget {
  MemberList({super.key});

  FetchMemberController fetchMemberController = Get.find<FetchMemberController>();
  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des membres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        /*
        child: Obx(() => fetchMemberController.fetchState.value == FetchState.LOADING ?
            Center(child: CircularProgressIndicator()) :
        SingleChildScrollView(
          child: Column(
            children: [
            //  Text("Compte : ${fetchMemberController.memberList.}")
              for(SingleMember member in fetchMemberController.members)
              SingleMemberInList(member),
            ],
          ),
        ),)



      ),
    );
         */
    child: Obx(
          () => fetchMemberController.fetchState.value == FetchMemberState.LOADING
          ? const Center(child: CircularProgressIndicator())
          : fetchMemberController.fetchState.value == FetchMemberState.ERROR ?
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Text("Une erreur est survenue. Actualisez la page en appuyant ",textAlign: TextAlign.center,),
                GestureDetector(
                    onTap: ()=>fetchMemberController.fetchMembersFromApi(fetchGoalsController.currentGoal.value.id ?? ""),
                    child: Text("Ici",textAlign: TextAlign.center,style: TextStyle(color: apCol,fontWeight: FontWeight.bold),)),
                const Text(" ou vérifiez votre connexion.",textAlign: TextAlign.center,),
              ],
            ),
          ) :
          ListView.separated(

        itemCount: fetchMemberController.members.length,
        itemBuilder: (BuildContext context, int index) {
          SingleMember member = fetchMemberController.members[index];
          return SingleMemberInList(member);
        }, separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 13.0,),
      ),
    ),
      ),
    );
  }
}
