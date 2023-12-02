import 'dart:convert';

import 'package:djizhub_light/auth/setting.dart';
import 'package:djizhub_light/goals/components/create_goal.dart';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';

import 'package:djizhub_light/utils/local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


import '../globals.dart';
import '../goals/components/account_list.dart';
import '../models/goals_model.dart';
class Home extends StatefulWidget {

   Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();


}





  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
  CreateGoalController createGoalController = Get.find<CreateGoalController>();




class _HomeState extends State<Home> {
  late TextEditingController _textController = TextEditingController();



  Future<void> _showModal() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Entrez l'url"),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(hintText: 'back url'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                createGoalController.setNewUrl(_textController.text);
                Navigator.of(context).pop();
              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {

    fetchGoalsController.getGoals();

    IO.Socket socket;
    Transaction transaction;
    FirebaseAuth.instance.currentUser?.getIdToken().then((value) =>{

    socket = IO.io("${createGoalController.backendUrl}",
    OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .disableAutoConnect()  // disable auto-connection
        .setExtraHeaders({'authorization': value }) // optional
        .build()),
        socket.connect(),
    socket.onConnectError((data) => print("connect error $data")),
    socket.onConnect((_) {
      print('connected successfully to websocket');
      socket.emit('msg', 'test');
    }),
    socket.on('update.goal', (goal) => {
      print(goal),
      fetchGoalsController.setUpdatedGoal(Goal.fromJson(goal)),
      fetchGoalsController.setCurrentGoal(Goal.fromJson(goal))
    }),
    socket.on('success.transaction', (data) =>{
       transaction = Transaction.fromJson(data),

    if(transaction.type == "DEPOSIT"){

      NotificationService()
        //  .showNotification(title: 'Transaction Réussie', body: "Votre dépot de ${transaction.amount} FCFA réalisé le ${transaction.createdAt?.day}/${transaction.createdAt?.month}/${transaction.createdAt?.year} à ${transaction.createdAt?.hour}H ${transaction.createdAt?.minute} par ${transaction.transactionOperator} a été réalisée avec succés.")
          .showNotification(title: 'Transaction Réussie', body: "Dépot de ${transaction.amount} FCFA réalisé avec succés.")
    }else{
      NotificationService()
          .showNotification(title: 'Transaction Réussi', body: "Vous avez retiré ${transaction.amount} FCFA avec succés.")
    },


    }

    ),
    socket.onDisconnect((_) => print('disconnect')),

    }

    );





/*

    print("hjfezjs");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showModal().then((value) => {


        fetchGoalsController.getGoals(),


      });



    });

    */
   // fetchGoalsController.getGoals();


  }



  @override
  Widget build(BuildContext context) {




    return Scaffold(
     // backgroundColor: apCol,
      appBar: AppBar(
       backgroundColor: lightGrey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Djizhub",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                  InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingPage())),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: apCol,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Icon(Icons.settings,color: Colors.white,),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width*0.7,
                height: 50,
                child: ElevatedButton(// foreground
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => lightGrey)
                  ),
                  onPressed:()=>Get.to(()=>CreateGoal()),
                  child: const Text('Créer une autre épargne',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            SizedBox(height: 25,),
            AccountList(),
          ],
        ),
      ),
    );
  }
}











/*
import 'package:djizhub_light/auth/setting.dart';
import 'package:djizhub_light/goals/components/create_goal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import '../goals/components/account_list.dart';
class Home extends StatelessWidget {

   Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: apCol,
      appBar: AppBar(
       backgroundColor: lightGrey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),
        title: Text(FirebaseAuth.instance.currentUser?.email ?? "Actif",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Djizhub",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                  InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingPage())),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: apCol,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Icon(Icons.settings,color: Colors.white,),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width*0.7,
                height: 50,
                child: ElevatedButton(// foreground
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => lightGrey)
                  ),
                  onPressed:()=>Get.to(()=>CreateGoal()),
                  child: const Text('Créer une autre épargne',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            SizedBox(height: 25,),
            AccountList(),
          ],
        ),
      ),
    );
  }
}

 */