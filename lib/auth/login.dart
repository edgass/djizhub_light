import 'package:flutter/material.dart';

import 'footer.dart';
import 'form.dart';
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
            //  LoginForm(),
              LoginFooter()
            ],
          ),
        ),
      ),
    );
  }
}
