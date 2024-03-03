import 'package:flutter/material.dart';
class ActionBox extends StatelessWidget {
  String title;
  Color backColor;
  Color iconColor;
  IconData icon;
  final VoidCallback function;

  ActionBox({super.key,required this.title,required this.backColor,required this.iconColor,required this.icon,required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.15,
            height: MediaQuery.of(context).size.width*0.15,
            decoration: BoxDecoration(
              color: backColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon,color: iconColor,)
            ),
          ),
          const SizedBox(height: 5,),
          Center(child: Text(title,style: const TextStyle(fontWeight: FontWeight.bold),))
        ],
      ),
    );
  }
}
