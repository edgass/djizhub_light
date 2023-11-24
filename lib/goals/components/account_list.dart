
import 'package:djizhub_light/goals/components/single_account_in_list.dart';
import 'package:flutter/material.dart';
class AccountList extends StatelessWidget {
  const AccountList({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        children: [
            SingleAccountInList(),
            SingleAccountInList(),
            SingleAccountInList(),
        ],
      ),
    );
  }
}
