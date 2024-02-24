import 'dart:async';
import 'dart:convert';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:djizhub_light/auth/controller/auth_controller.dart';
import 'package:djizhub_light/auth/setting.dart';
import 'package:djizhub_light/goals/components/choose_create_goal_type.dart';
import 'package:djizhub_light/goals/components/create_goal.dart';
import 'package:djizhub_light/goals/controllers/create_goal_controller.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/goals/controllers/joinGoalController.dart';
import 'package:djizhub_light/home/socket_controller.dart';
import 'package:djizhub_light/transactions/controllers/deposit_controller.dart';

import 'package:djizhub_light/utils/local_notifications.dart';
import 'package:djizhub_light/utils/security/security_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:intl/intl.dart';


import '../globals.dart';
import '../goals/components/account_list.dart';
import '../models/goals_model.dart';
class Home extends StatefulWidget {

   Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();


}

final _joinFormKey = GlobalKey<FormState>();



  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
  CreateGoalController createGoalController = Get.find<CreateGoalController>();
  DepositController depositController = Get.find<DepositController>();
  SecurityController securityController = Get.find<SecurityController>();
  AuthController authController = Get.find<AuthController>();
  JoinGoalController joinGoalController = Get.find<JoinGoalController>();
  SocketController socketController = Get.find<SocketController>();

TextEditingController codeController = TextEditingController();




class _HomeState extends State<Home> {
  late TextEditingController _textController = TextEditingController();
  Timer? _timer;
  var formatter = NumberFormat("#,###");
  final RefreshController _refreshController = RefreshController(initialRefresh: false,initialRefreshStatus: RefreshStatus.idle);
  void _onRefresh() async{
    // monitor network fetch
   //  await fetchGoalsController.getGoals();
    // if failed,use refreshFailed()


        _refreshController.refreshToIdle();
        fetchGoalsController.getGoals();






  }




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
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState(){

    super.initState();
    initDynamicLinks().then((value) =>print("Done"));
    fetchGoalsController.getGoals();



    socketController.connectToWebsocket();

  }

  Future<void> initDynamicLinks() async {

    print("Try to start dynamique link listener");

    dynamicLinks.onLink.listen((dynamicLinkData) {
      print("Listening dynamique link");
      handleDynamicLink(dynamicLinkData);
    }).onError((error) {
      print('onLink error $error');
      print(error.message);
    });

    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    if (data?.link != null) {
      print("Handling initial link");
      handleDynamicLink(data!);
    }
  }

  void handleDynamicLink(PendingDynamicLinkData data) {
    print("hjwhhjbsbkjbesbe");
    final Uri? deepLink = data.link;

    if (deepLink != null) {
      String name = deepLink.queryParameters['name'] ?? '';
      String code = deepLink.queryParameters['code'] ?? '';
      if (code.isNotEmpty) {
        _showAddForeignAccountDialog(context);
      }
    }
  }
  @override
  void dispose() {
    _timer?.cancel(); // Assurez-vous d'annuler le minuteur lors de la suppression de l'objet State
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {




    return Scaffold(
     // backgroundColor: apCol,
      appBar: AppBar(

       backgroundColor: lightGrey,
     actions: [
       InkWell(
         onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) =>  SettingPage())),
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
       )
     ],
     /*   shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),

      */title: Image.asset('assets/logo/header_logo.png',width: 120,),
        automaticallyImplyLeading: false,

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23)
            ),
            child: Column(
              children: [
           /*     Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Djizhub",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                      InkWell(
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) =>  SettingPage())),
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

            */
               AnimatedSizeAndFade(
                 fadeDuration: const Duration(milliseconds: 300),
                 sizeDuration: const Duration(milliseconds: 600),
                 child: Obx(() => authController.myConnexionState.value == MyconnexionState.noInternet ?
                     Container(
                       height: 23,
                       width: MediaQuery.of(context).size.width,
                       color: Colors.grey.shade100,
                       child: Text("Vérifiez votre Connexion",style: TextStyle(color: Colors.black87),textAlign: TextAlign.center),
                     ) : authController.myConnexionState.value == MyconnexionState.backToInternet ?
                 Container(
                   height: 23,
                   width: MediaQuery.of(context).size.width,
                   color: Colors.green,
                   child: Text("De retour sur internet",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                 ) : const SizedBox()
                 ),
               )
              ],
            ),
          ),
        ),
      ),
      body: SmartRefresher(
        footer: const ClassicFooter(
            loadStyle: LoadStyle.HideAlways),
        enablePullDown: true,
        //enablePullUp: true,
        header:  WaterDropHeader(waterDropColor:authController.myConnexionState.value == MyconnexionState.noInternet ?Colors.grey.shade100 : lightGrey  ),
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: SingleChildScrollView(
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
                    onPressed:()=>Get.to(()=>ChooseCreateGoalType()),
                   // onPressed:()=>Get.to(()=>CreateGoal()),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(4)
                          ),
                            child: Icon(Icons.add,color: Colors.white,size: 18,)),
                        SizedBox(width: 5,),
                        Text('Nouveau coffre',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 13,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ou  "),
                  InkWell(
                      onTap: ()=>_showAddForeignAccountDialog(context),
                      child: Text("Rejoindre un coffre",style: TextStyle(color: lightGrey),)),
                ],
              ),

              SizedBox(height: 20,),

              AccountList(),
            ],
          ),
        ),
      ),
    );
  }
}











Future<void> _showAddForeignAccountDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Form(
        key: _joinFormKey,
        child: GetBuilder<JoinGoalController>(
          builder: (value)=>AlertDialog(
            title: const Text('Rejoindre un coffre'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SizedBox(height: 10,),
                  TextFormField(

                    initialValue: authController.userName ?? FirebaseAuth.instance.currentUser?.displayName,
                    onChanged: (value){
                      depositController.setNameToSend(value);
                    },
                    decoration: InputDecoration(
                      labelText: "Prénom et nom",
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Ce champs est obligatoire';
                      }
                      List<String> names = val.split(' ');

                      if (names.length < 2 ||
                          names[0].length <2  ||
                          names[1].length < 2) {
                        return 'Veuillez entrer un prénom et nom valides';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10,),
                //  Text("Veuillez entrer le code du coffre."),
               //   Text("C'est un code à 4 caractéres.",style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),),
                  SizedBox(height: 10,),
                  TextFormField(
                    inputFormatters: [UpperCaseTextFormatter()],
                    maxLength: 4,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Ce champs est obligatoire';
                      }else if(value?.length != 4){
                        return 'Format de code incorrecte';
                      }
                      return null;
                    },
                    controller: codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        hintText: 'Code du compte',
                        helperMaxLines: 3,
                        helperText: "Demandez au propriétaire du compte de vous fournir le code d'adhésion, puis saisissez-le ici.",
                        counterText: "",
                    ),
                  ),

                ],
              ),
            ),
            actions: <Widget>[
              value.joinGoalState == JoinGoalState.LOADING ? SizedBox() :
              TextButton(
                child: const Text('Annuler',style: TextStyle(color: Colors.deepOrangeAccent),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              value.joinGoalState == JoinGoalState.LOADING ? CircularProgressIndicator() :
              TextButton(
                child: const Text('Ajouter'),
                onPressed: () {
                  if (_joinFormKey.currentState!.validate()){
                    FocusScope.of(context).unfocus();
                    joinGoalController.joinGoal(context, codeController.text,depositController.nameToSend.toString());
                  }

                },
              )

            ],
          ),
        ),
      );
    },
  );
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text!.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

