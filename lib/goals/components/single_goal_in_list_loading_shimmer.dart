
import 'package:circulito/circulito.dart';
import 'package:djizhub_light/goals/components/info_box_loading_shimmer.dart';
import 'package:djizhub_light/goals/controllers/fetch_goals_controller.dart';
import 'package:djizhub_light/home/info_box.dart';
import 'package:djizhub_light/models/goals_model.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';
import 'account_details.dart';
class SingleGoalInListLoadingShimmer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width*0.8,
        height: MediaQuery.of(context).size.width*0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [

            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 20,
              offset: const Offset(0, 1),
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
                        FadeShimmer( radius: 10,  highlightColor: Color(0xffF9F9FB),
                            baseColor: Color(0xffE6E8EB), width: 60, height: 10),
                        SizedBox(height: 12,),
                        FadeShimmer( radius: 10,  highlightColor: Color(0xffF9F9FB),
                            baseColor: Color(0xffE6E8EB), width: 100, height: 10),

                      ],
                    ),


                    Container(
                      width: 50,
                      height: 50,
                      /*
                      decoration: BoxDecoration(
                        color: apCol,
                        borderRadius: BorderRadius.circular(15)
                      ),

                       */
                      //     child: Icon(Icons.money,color: Colors.white,),

                      child:  Circulito(
                        background: CirculitoBackground(
                          decoration: const CirculitoDecoration.fromColor(Colors.black12),
                        ) ,


                        animation: CirculitoAnimation(
                          duration: 600,
                          curve: Curves.easeInOut,
                        ),
                        strokeWidth: 5,
                        maxSize: 50,
                        sections: [
                          // One single section at 50%.
                          CirculitoSection(

                            value: (100/100),
                            //   decoration: CirculitoDecoration.fromColor(fetchGoalsController.getColorFromValue(currentGoal.percent_progress!.toInt() ?? 0)),
                            decoration: CirculitoDecoration.fromColor(Color(0xffF9F9FB)),
                          )
                        ],
                      ),

                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                 InfoBoxLoadingShimmer(),
                 InfoBoxLoadingShimmer()
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
