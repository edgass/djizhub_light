import 'package:djizhub_light/globals.dart';
import 'package:flutter/material.dart';
class InfoBox extends StatelessWidget {
  String title;
  double price;
  bool designShadow;
   InfoBox({Key? key,required this.title,required this.price,required this.designShadow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.3,
      height: MediaQuery.of(context).size.width*0.3,
      decoration: BoxDecoration(
        color: designShadow ? Colors.grey.shade100 : Colors.white12,
        borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: designShadow ? Colors.grey.shade300 : Colors.grey.shade50,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 5),
            )
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: Text(title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: apCol),)),
            Container(child: Text("$price FCFA",textAlign:TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black))),
            SizedBox(height: 1,)
          ],
        ),
      ),
    );
  }
}
