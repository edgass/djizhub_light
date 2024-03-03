import 'package:flutter/material.dart';

import '../../globals.dart';
class TransactionsActions extends StatelessWidget {
  const TransactionsActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          children: [

            //Heder Question
            SizedBox(
              width: MediaQuery.of(context).size.width*0.7,
                child: const Text("Que voulez vous faire ?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),)),
            const SizedBox(height: 50,),
            //List des actions
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Row(
                       children: [
                         Container(
                           width: 50,
                           height: 50,
                           decoration: BoxDecoration(
                               color: Colors.blueAccent,
                               borderRadius: BorderRadius.circular(10)
                           ),
                           child: const Icon(Icons.arrow_downward),
                         ),
                         const Padding(
                           padding: EdgeInsets.only(left: 15.0),
                           child: Text("Depot",style: TextStyle(fontSize:25),),
                         ),
                       ],
                     ),
                      const Icon(Icons.arrow_forward_ios_sharp,)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: const Icon(Icons.arrow_upward),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text("Retrait",style: TextStyle(fontSize:25),),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios_sharp,)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: const Icon(Icons.settings),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text("Reglage",style: TextStyle(fontSize:25,),),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios_sharp,)

                    ],
                  ),
                ),
              ],
            ),

            //Buton Fermer
            Expanded(
              child: GestureDetector(
                onTap: ()=>Navigator.pop(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                   decoration: BoxDecoration(
                     color: apCol,
                     borderRadius: BorderRadius.circular(20)
                   ),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Text("Fermer"),
                            Icon(Icons.close),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
