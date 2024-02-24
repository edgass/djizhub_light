import 'package:djizhub_light/goals/components/single_member_in_list.dart';
import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/models/member_list_model.dart';
import 'package:djizhub_light/transactions/controllers/fetch_member_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MemberList extends StatelessWidget {
  MemberList({super.key});

  FetchMemberController fetchMemberController = Get.find<FetchMemberController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des membres'),
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
          () => fetchMemberController.fetchState.value == FetchState.LOADING
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(

        itemCount: fetchMemberController.members.length,
        itemBuilder: (BuildContext context, int index) {
          SingleMember member = fetchMemberController.members[index];
          return SingleMemberInList(member);
        }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 13.0,),
      ),
    ),
      ),
    );
  }
}
