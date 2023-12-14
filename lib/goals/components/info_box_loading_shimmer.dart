import 'package:djizhub_light/globals.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class InfoBoxLoadingShimmer extends StatelessWidget {
  InfoBoxLoadingShimmer({Key? key}) : super(key: key);
  var formatter = NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    return Container(
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
            FadeShimmer( radius: 10,  highlightColor: Color(0xffF9F9FB),
                baseColor: Color(0xffE6E8EB), width: 50, height: 12),
            SizedBox(height: 12,),
            FadeShimmer(  radius: 10, highlightColor: Color(0xffF9F9FB),
                baseColor: Color(0xffE6E8EB), width: 80, height: 12),
            SizedBox(height: 1,),
            FadeShimmer( radius: 10,  highlightColor: Color(0xffF9F9FB),
                baseColor: Color(0xffE6E8EB), width: 80, height: 12),
          ],
        ),
      ),
    );
  }
}
