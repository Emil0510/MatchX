import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/pages/sign_in_sign_up/log_in/log_in_cubit/log_in_cubit.dart';
import 'package:flutter_app/pages/sign_in_sign_up/sign_up/sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'log_in/log_in.dart';

class SignInSignUp extends StatefulWidget {
  const SignInSignUp({super.key});

  @override
  State<SignInSignUp> createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp>
    with SingleTickerProviderStateMixin {
  late bool isLogin;
  late String firstText;
  late String secondText;

  void signUpClicked() {
    setState(() {
      if (isLogin) {
        isLogin = false;
        firstText = "Artıq hesabınız var? ";
        secondText = "Daxil Ol";
      } else {
        isLogin = true;
        firstText = "Hesabınız yoxdur? ";
        secondText = "Qeydiyyatdan keç";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isLogin = true;
    firstText = "Hesabınız yoxdur? ";
    secondText = "Qeydiyyatdan keç";
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  void toLogIn() {
    setState(() {
      isLogin = true;
      firstText = "Hesabınız yoxdur? ";
      secondText = "Qeydiyyatdan keç";
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // Avoid scaffold resizing when keyboard appears
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      height: height,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                        // Adjust the radius value as needed
                        color: Colors.black, // Adjust the color as needed
                      ),
                      child: ClipRRect(
                        child: Column(
                          children: [
                            SizedBox(
                              height: height,
                              child: isLogin
                                  ? BlocProvider(
                                      create: (BuildContext context) =>
                                          LogInCubit(),
                                      child: const LogIn())
                                  : SignUp(
                                      toLogIn: toLogIn,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: height / 15 ,
                left: 10,
                right: 10,
                child: Container(
                  width: double.maxFinite,
                  child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: signUpClicked,
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: firstText,
                                style: const TextStyle(color: Colors.white)),
                            TextSpan(
                              text: secondText,
                              style: const TextStyle(
                                  color: Color(goldColor)),
                            )
                          ]),
                        ),
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
