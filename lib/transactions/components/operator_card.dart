import 'package:djizhub_light/globals.dart';
import 'package:djizhub_light/transactions/controllers/deposit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class OperatorCard extends StatelessWidget {
  String name;
  String assetPath;
  Operator operator;
   OperatorCard({super.key,required this.name,required this.assetPath,required this.operator});
   DepositController depositController = Get.find<DepositController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositController>(

        builder: (value)=>InkWell(
          onTap: (){
            depositController.setOperator(operator);
          },
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: value.operator == operator ? Border.all(color: lightGrey,width: 2) : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.2,
                  height: MediaQuery.of(context).size.width*0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: new ExactAssetImage(assetPath),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  child: Text(""),
                ),
                SizedBox(height: 5,),
                Text(name)
              ],
            ),
          ),
        )
    );
  }
}
