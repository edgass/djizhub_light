import 'package:flutter/material.dart';
class SingleTransactionInList extends StatelessWidget {
  const SingleTransactionInList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.mobile_friendly),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Free Money",style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
                SizedBox(height: 4,),
                Text("12/05/2022 à 10h 30",style: TextStyle(),),
              ],
            ),
          ),
          Expanded(
              child: Text("+5000 FCFA",textAlign:TextAlign.right,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),)
          )
        ],
      ),
    );
  }
}
