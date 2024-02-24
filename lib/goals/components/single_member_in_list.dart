import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/models/member_list_model.dart';
import 'package:djizhub_light/transactions/components/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class SingleMemberInList extends StatelessWidget {
  SingleMember member;
   SingleMemberInList(this.member,{super.key});
  var formatter = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GestureDetector(
          onTap: ()=>{
            if(member.transactions!.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Aucune transaction éffectuée pour le moment"),backgroundColor: Colors.grey,)
        )
            }else{
              Get.to(()=>TransactionList(member))
            }
          },
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
             // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.3,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.name ?? "",overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 2,),
                      Text("A rejoint le ${member.createdAt?.day.toString().padLeft(2, '0')}/${member.createdAt?.month.toString().padLeft(2, '0')}/${member.createdAt?.year}",overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 2,),
                      member.out ?? false ?
                      Text("A Quitté",style: TextStyle(color: Colors.red)) :
                      Text("Actif",style: TextStyle(color: Colors.green),)
                    ],
                  ),
                ),
                SizedBox(

                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("${member.count} transaction(s)",style: TextStyle(fontWeight: FontWeight.bold),),

                          Row(
                            children: [
                              Text("${formatter.format(member.total)} Fcfa",style: TextStyle(color: apCol),),
                              Text(" au total"),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.circular(50)),
                              width: 20,
                              height: 20,
                              child: Icon(Icons.arrow_forward_ios,size: 12,color: Colors.white,),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
