import 'package:flutter/material.dart';
class JoinAccountByLink extends StatelessWidget {
   JoinAccountByLink({super.key});
   static const route = 'JoinAccountByLink-page';

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('Joindre le coffre'),),
     // body: Text('${message.notification?.title}'),
      body: Text('$message'),
    );
  }
}
