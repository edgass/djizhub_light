import 'package:djizhub_light/goals/components/single_goal_in_list_loading_shimmer.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';
class GoalsLoadingShimmer extends StatelessWidget {
  const GoalsLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          FadeShimmer(
            width: 145,
            height: 35,
            radius: 15,
            highlightColor: Color(0xffF9F9FB),
            baseColor: Color(0xffE6E8EB),
          ),
    Padding(
      padding: const EdgeInsets.only(top: 15.0,bottom: 15.0),
      child: Column(
        children: [

            SingleGoalInListLoadingShimmer(),
            SingleGoalInListLoadingShimmer(),
            SingleGoalInListLoadingShimmer(),
        ],
      ),
    ),

        ],
      );
  }
}
