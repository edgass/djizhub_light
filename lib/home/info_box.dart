import 'package:djizhub_light/globals.dart';
import 'package:flutter/material.dart';
class InfoBox extends StatelessWidget {
  String title;
  double price;
   InfoBox({Key? key,required this.title,required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.3,
      height: MediaQuery.of(context).size.width*0.3,
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(25)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: apCol),),
            Container(child: Text("$price FCFA",textAlign:TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black))),
            SizedBox(height: 1,)
          ],
        ),
      ),
    );
  }
}
