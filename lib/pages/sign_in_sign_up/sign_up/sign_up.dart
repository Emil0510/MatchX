import 'package:flutter/material.dart';
import 'package:flutter_app/pages/sign_in_sign_up/sign_up/sign_up_stages.dart';

class SignUp extends StatefulWidget {
  final Function toLogIn;
  const SignUp({super.key, required this.toLogIn});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    super.initState();
  }

  void toLogIn(){
    widget.toLogIn();
  }

  @override
  Widget build(BuildContext context) {
    return CreateAccount(toLogIn: toLogIn,);
  }
}
