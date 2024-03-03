import 'package:djizhub_light/globals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class InfoBox extends StatelessWidget {
  String title;
  double price;
  bool designShadow;
   InfoBox({super.key,required this.title,required this.price,required this.designShadow});
    var formatter = NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.3,
      height: MediaQuery.of(context).size.width*0.3,
     /* decoration: BoxDecoration(
        color: designShadow ? Colors.grey.shade100 : Colors.white12,
        borderRadius: BorderRadius.circular(25),

      ), */
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: apCol),),
            Text("${formatter.format(price)}\nFCFA",textAlign:TextAlign.center,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
            const SizedBox(height: 1,)
          ],
        ),
      ),
    );
  }
}
