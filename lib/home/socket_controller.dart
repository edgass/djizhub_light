
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/transactions/controllers/deposit_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../models/goals_model.dart';
import '../utils/local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:intl/intl.dart';

class SocketController extends GetxController{

  FetchGoalsController fetchGoalsController = Get.find<FetchGoalsController>();
  DepositController depositController = Get.find<DepositController>();
  late IO.Socket socket;

  connectToWebsocket(){
    var formatter = NumberFormat("#,###");


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
        fetchGoalsController.saveGoalsToCache(),
        fetchGoalsController.setCurrentGoal(Goal.fromJson(goal))
      }),
      socket.on('success.transaction', (data) =>{
        transaction = Transaction.fromJson(data),

        if(transaction.type == "DEPOSIT"){

          NotificationService()
              .showNotification(id: depositController.generateRandomNotificationId(),title: 'Transaction Réussie', body: "Votre dépot de ${transaction.amount} FCFA réalisé le ${transaction.createdAt?.day.toString().padLeft(2,'0')}/${transaction.createdAt?.month.toString().padLeft(2,'0')}/${transaction.createdAt?.year} à ${transaction.createdAt?.hour.toString().padLeft(2,'0')}H ${transaction.createdAt?.minute.toString().padLeft(2,'0')} par ${transaction.transactionOperator} a été réalisée avec succés.",payLoad: '')
          //  .showNotification(title: 'Transaction Réussie', body: "Dépot de ${transaction.amount} FCFA réalisé avec succés.")
        }else{
          NotificationService()
              .showNotification(id: depositController.generateRandomNotificationId(),title: 'Transaction Réussi', body: "Vous avez retiré avec succés la somme de ${formatter.format(transaction.amount)} FCFA par ${transaction.transactionOperator} le ${transaction.createdAt?.day.toString().padLeft(2,'0')}/${transaction.createdAt?.month.toString().padLeft(2,'0')}/${transaction.createdAt?.year} à ${transaction.createdAt?.hour.toString().padLeft(2,'0')}H ${transaction.createdAt?.minute.toString().padLeft(2,'0')}",payLoad: '')
        },


      }

      ),
      socket.onDisconnect((_) => print('disconnect socket')),


    }

    );
  }

  disconnectToWebsocket(){
    socket.disconnect();
    socket.clearListeners();
    print("Disconnected to websocket");
  }
}