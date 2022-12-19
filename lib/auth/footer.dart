import 'package:flutter/material.dart';

import '../globals.dart';
class LoginFooter extends StatelessWidget {
  const LoginFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.delivery_dining_rounded,color: apCol,),
          SizedBox(width: 10,),
      //    Flexible(child: Text("Votre conciergerie numérique, nous vous transportons tous vos désirs* / Simple-rapide-sur",style: TextStyle(fontSize: 9),)) ,
          Flexible(child: RichText(
            text: TextSpan(
              text: "Votre conciergerie numérique, nous vous transportons tous vos désirs* / ",
              style: TextStyle(color: Colors.black, fontSize: 9),
              children: <TextSpan>[
                TextSpan(text: 'Simple-Rapide-sûr', style: TextStyle(color: apCol,fontWeight: FontWeight.bold)),
              ],
            ),
          )) ,
        ],
      ),
    );
  }
}
