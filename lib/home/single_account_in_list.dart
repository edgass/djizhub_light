import 'package:djizhub_light/home/account_details.dart';
import 'package:djizhub_light/home/info_box.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
class SingleAccountInList extends StatelessWidget {
  const SingleAccountInList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const AccoutDetails())),
        child: Container(
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.width*0.7,
          decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.overlay,
            borderRadius: BorderRadius.circular(35),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0.1), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 25.0,bottom: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Achat de Voiture",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.black54),),
                          Text("Retrait : 12/01/2023",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)),
                        ],
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: apCol,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Icon(Icons.money,color: Colors.white,),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InfoBox(title: "Solde",price: 14000),
                    InfoBox(title: "Objectif",price: 25000),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
