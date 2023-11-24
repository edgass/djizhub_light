
import 'package:djizhub_light/home/info_box.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';
import 'account_details.dart';
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
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(5, 5),
              ),
              const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-5,-5),
                  blurRadius: 15,
                  spreadRadius: 1
              ) ,
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade300,
                Colors.grey.shade400,
                Colors.grey.shade500,
              ],
            ),
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
                    InfoBox(title: "Solde",price: 14000,designShadow: false,),
                    InfoBox(title: "Objectif",price: 25000,designShadow: false,),
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
