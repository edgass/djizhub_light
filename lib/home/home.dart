import 'package:djizhub_light/home/account_list.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: apCol,
      appBar: AppBar(
      // backgroundColor: Color(0xFF70bccc),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(35),
          ),
        ),
        title: Text('+221 77 247 77 30',style: TextStyle(fontWeight: FontWeight.bold),),
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
                  Padding(
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
                  Text("Djizhub",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),)
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
                      backgroundColor: MaterialStateColor.resolveWith((states) => Color(0XFF35BBCA))
                  ),
                  onPressed:null,
                  child: const Text('Cr??er une autre ??pargne',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
