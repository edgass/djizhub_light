

import 'dart:convert';
import 'dart:core';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

import '../../models/member_list_model.dart';

enum FetchMemberState {
  PENDING,LOADING,ERROR,SUCCESS

}


enum FetchSingleTransactionState {
  PENDING,LOADING,ERROR,SUCCESS

}
CreateGoalController createGoalController = Get.find<CreateGoalController>();


class FetchMemberController extends GetxController{

  Rx<int> selectedTab = 0.obs;
  RxList<SingleMember> members = <SingleMember>[].obs;
  MemberListModel memberList = MemberListModel();
  double goalPercentage = 0;
  Rx<FetchMemberState> fetchState = FetchMemberState.PENDING.obs;
  FetchSingleTransactionState fetchSingleTransactionState = FetchSingleTransactionState.PENDING;
  final storage = const FlutterSecureStorage();


  @override
  void onInit() {
    // TODO: implement onInit
    /*
   var _channel = WebSocketChannel.connect(
     Uri.parse('wss://bb9e-41-83-20-74.ngrok-free.app:3000',),
   ).printError();
*/
    // Create a WebSocket client.




  }

  Future<void> fetchMembersFromApi(String idAccount) async {
    String url = "${createGoalController.backendUrl}/goals/$idAccount/guests";


    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    fetchState.value = FetchMemberState.LOADING;

    var response = await http.get(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $idToken',
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response('Error', 408); // Request Timeout response status code
      },
    );
    if (response.statusCode == 200) {

      memberList= memberListModelFromJson(response.body);
      members.value = memberList.data ?? [];
      fetchState.value = FetchMemberState.SUCCESS;
      update();
    } else {
      fetchState.value = FetchMemberState.ERROR;
      update();
    }

    print(response.statusCode);
  }


}