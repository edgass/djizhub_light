

import 'dart:convert';
import 'dart:core';
import 'dart:ffi';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import '../../home/home.dart';
import '../../models/goals_model.dart';
import '../../models/number_list_model.dart';

enum FetchState {
  PENDING,LOADING,ERROR,SUCCESS

}

enum FetchNumbersState {
  PENDING,LOADING,ERROR,SUCCESS

}

enum FetchSingleGoalState {
  PENDING,LOADING,ERROR,SUCCESS

}

enum FetchSingleTransactionState {
  PENDING,LOADING,ERROR,SUCCESS

}
CreateGoalController createGoalController = Get.find<CreateGoalController>();


class FetchGoalsController extends GetxController{

 Rx<int> selectedTab = 0.obs;
 RxList<Goal> goals = <Goal>[].obs;
 RxList<Goal> openedGoals = <Goal>[].obs;
 RxList<Goal> closedGoals = <Goal>[].obs;
 Rx<Goal> currentGoal = Goal().obs;
 double goalPercentage = 0;
 List<String> numbers = [];
 Transaction currentTransaction = Transaction();
 Rx<FetchState> fetchState = FetchState.PENDING.obs;
 Rx<FetchNumbersState> fetchNumbersState = FetchNumbersState.PENDING.obs;
 Rx<FetchSingleGoalState> fetchSingleGoalState = FetchSingleGoalState.PENDING.obs;
 FetchSingleTransactionState fetchSingleTransactionState = FetchSingleTransactionState.PENDING;
 AuthController authController = Get.find<AuthController>();
 final storage = const FlutterSecureStorage();
 String backendUrl = appUrl;


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

 Future<List<Goal>?> loadGoalsFromCache() async {
   var goalListString = await storage.read(key: 'goals');

   // Récupérer la chaîne JSON depuis la cache
   if (goalListString != null) {
     // Convertir la chaîne JSON en une liste d'objets
     List<Goal> loadedGoalList = (jsonDecode(goalListString) as List).map((item) => Goal.fromJson(item)).toList();
     print("loaded goals $loadedGoalList");
     // Mettre à jour l'état de la liste
   goals.value = loadedGoalList;
   return loadedGoalList;
   }
 }

 void saveGoalsToCache() async {
   // Convertir la liste en une chaîne JSON
   String goealListString = jsonEncode(goals.value);
   // Enregistrer la chaîne JSON dans la cache
   await storage.write(key: 'goals', value: goealListString);
 }

 Future<List<String>?> loadNumbersFromCache() async {
   var numbersListString = await storage.read(key: 'numbers');

   // Récupérer la chaîne JSON depuis la cache
   if (numbersListString != null) {
     // Convertir la chaîne JSON en une liste d'objets
     List<dynamic> loadedNumbersList = jsonDecode(numbersListString);
     List<String> convertedNumbersList = loadedNumbersList.map((e) => e.toString()).toList();
     print("loaded numbers $loadedNumbersList");
     // Mettre à jour l'état de la liste
     numbers = convertedNumbersList;
     return convertedNumbersList;
   }
 }

 void saveNumbersToCache() async {
   // Convertir la liste en une chaîne JSON
   String numbersListString = jsonEncode(numbers);
   // Enregistrer la chaîne JSON dans la cache
   await storage.write(key: 'numbers', value: numbersListString);
 }

 Future getGoals() async {
   fetchState.value = FetchState.LOADING;
   final hasInternet = await InternetConnectivity().hasInternetConnection;
   if (!hasInternet) {
     loadGoalsFromCache().then((value) {
       if (value != null) {
         openedGoals.value = [];
         closedGoals.value = [];
         goals.value = value;

         for (var i = 0; i < goals.length; i++) {
           if (goals[i].status != "WITHDRAWN") {
             openedGoals.add(goals[i]);
           } else {
             closedGoals.add(goals[i]);
           }
         }
         fetchState.value = FetchState.SUCCESS;
         update();
       } else {
         fetchGoalsFromApi();
       }
     });
   }else{
     fetchGoalsFromApi();
   }
 }

 Future<void> fetchGoalsFromApi() async {
   String url = "${createGoalController.backendUrl}/goals";


   final User? user = FirebaseAuth.instance.currentUser;
   final idToken = await user?.getIdToken();
   fetchState.value = FetchState.LOADING;
    print("from fetch fcm from authController test : ${authController.fcmToken}");
   var response = await http.get(Uri.parse(url),
       headers: {
         'Content-Type': 'application/json',
         'Accept': 'application/json',
         'Authorization': 'Bearer $idToken',
         'fcm-token': authController.fcmToken ?? "",
       });
   print(response.body);

   if (response.statusCode == 200) {
     openedGoals.value = [];
     closedGoals.value = [];
     goals.value = goalsFromJson(response.body).data ?? [];
     saveGoalsToCache();
     for (var i = 0; i < goals.length; i++) {
       if (goals[i].status != "WITHDRAWN") {
         openedGoals.add(goals[i]);
       } else {
         closedGoals.add(goals[i]);
       }
     }
     fetchState.value = FetchState.SUCCESS;
     update();

   } else {
     fetchState.value = FetchState.ERROR;
     update();
   }

   print(response.statusCode);
 }

 Future<void> fetchUserNumbers() async {
   String url = "${createGoalController.backendUrl}/goals/numbers";


   final User? user = FirebaseAuth.instance.currentUser;
   final idToken = await user?.getIdToken();
   fetchNumbersState.value = FetchNumbersState.LOADING;
   try{
     var response = await http.get(Uri.parse(url),
         headers: {
           'Content-Type': 'application/json',
           'Accept': 'application/json',
           'Authorization': 'Bearer $idToken',
           'fcm-token': authController.fcmToken ?? "",
         });

     if (response.statusCode == 200) {
       numbers = numberListFromJson(response.body).data ?? [];
       print("numbers list : "+ numbers.toString());
       saveNumbersToCache();
       fetchNumbersState.value = FetchNumbersState.SUCCESS;
       update();

     } else {
       fetchNumbersState.value = FetchNumbersState.ERROR;
       update();
     }
   }catch(e){
     fetchNumbersState.value = FetchNumbersState.ERROR;
     update();
   }

 }

  getSingleGoal(String idGoal) async {
   print("executing get goals ");
   String url = "$backendUrl/goals";


   final user = FirebaseAuth.instance.currentUser!;
   final idToken = await user.getIdToken();
   fetchState.value = FetchState.LOADING;
   update();

   final response = await http.get(Uri.parse("$url/$idGoal"),
       headers: {
         'Content-Type': 'application/json',
         'Accept': 'application/json',
         'Authorization': 'Bearer $idToken',
       });


   if (response.statusCode == 200) {

     fetchState.value = FetchState.SUCCESS;
     update();
     print(" get goals executed");

   } else {
     print(response.body);
     fetchState.value = FetchState.ERROR;
     update();
   }
   print(response.statusCode);
 }

 void getSingleTransaction() async {
   String url = "$backendUrl/goals";


   final user = FirebaseAuth.instance.currentUser!;
   final idToken = await user.getIdToken();
   fetchState.value = FetchState.LOADING;
   update();

   final response = await http.get(Uri.parse(url),
       headers: {
         'Content-Type': 'application/json',
         'Accept': 'application/json',
         'Authorization': 'Bearer $idToken',
       });


   if (response.statusCode == 200) {
     goals.value = goalsFromJson(response.body).data ?? [];
     fetchState.value = FetchState.SUCCESS;
     update();

   } else {
     fetchState.value = FetchState.ERROR;
     update();
   }
   print(response.statusCode);
 }

   setCurrentGoal(Goal goal) {
   currentGoal.value = goal;
   fetchSingleGoalState.value = FetchSingleGoalState.SUCCESS;
  }

 setCurrentTransaction(Transaction transaction) {
   currentTransaction = transaction;
   fetchSingleTransactionState = FetchSingleTransactionState.SUCCESS;
   update();
 }

 setSelectedTab(int tab){
   selectedTab.value = tab;
 }

 setUpdatedGoal(Goal goal){
   int index = goals.value.indexWhere((item) => item.id == goal.id);
   if (index != -1) {
     goals[index] = goal;
   }else{
     goals.insert(0,goal);
   }
  openedGoals.value = [];
  closedGoals.value = [];
   for(var i=0;i<goals.length;i++){
     if(goals[i].status != "WITHDRAWN"){
       openedGoals.add(goals[i]);
     }else{
       closedGoals.add(goals[i]);
     }
   }
  fetchState.value = FetchState.SUCCESS;
 }

 addNewGoal(Goal goal){
   print("goooaaaaaall : ${goal.balance}");
    goals.add(goal);
    for(var i=0;i<goals.length;i++){
      if(goals[i].status != "WITHDRAWN"){
        openedGoals.add(goals[i]);
      }else{
        closedGoals.add(goals[i]);
      }
    }
 }

 String transformNumberWithSpace(String phoneNumber){
   // Vérifier si la longueur du numéro de téléphone est valide
   if (phoneNumber.length != 9) {
     // Retourner une chaîne vide si la longueur du numéro de téléphone n'est pas valide
     return '';
   }

   // Ajouter les espaces au numéro de téléphone
   String formattedPhoneNumber = '${phoneNumber.substring(0, 2)} ${phoneNumber.substring(2, 5)} ${phoneNumber.substring(5, 7)} ${phoneNumber.substring(7)}';

   return formattedPhoneNumber;
 }

 Color getColorFromValue(int value) {
   // Assure que la valeur est dans la plage de 0 à 100
   value = value.clamp(0, 100);

   // Calcule les composants de couleur en fonction de la valeur
   int red = (255 - (255 * value / 100)).round();
   int green = (255 * value / 100).round();

   // Crée et renvoie la couleur correspondante
   return Color.fromRGBO(red, green, 0, 0.6);
 }

 void main() {
   // Test de la fonction avec différentes valeurs
   for (int i = 0; i <= 100; i += 10) {
     Color color = getColorFromValue(i);
     print('Valeur: $i, Couleur: $color');
   }
 }


}