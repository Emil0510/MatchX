import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/home.dart';
import 'package:flutter_app/pages/sign_in_sign_up/ForgotPasswordPage.dart';
import 'package:flutter_app/pages/sign_in_sign_up/log_in/log_in_cubit/log_in_cubit.dart';
import 'package:flutter_app/pages/sign_in_sign_up/log_in/log_in_cubit/log_in_cubit_states.dart';
import 'package:flutter_app/pages/sign_in_sign_up/log_in/widget/log_in_button.dart';
import 'package:flutter_app/widgets/container.dart';
import 'package:flutter_app/widgets/input_text_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../chat/cubit/chat_cubit.dart';
import '../../home/home_cubit/home_cubit.dart';
import '../../notification_page/notification_cubit/notification_cubit.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late double distanceBetweenWidget;
  late bool _passwordVisible;
  late bool isLoading = false;

  void onPressed() {
    String username = usernameController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    context.read<LogInCubit>().logIn(username, password);
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    distanceBetweenWidget = height / 30;

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned(
            top: height / 5,
            left: 10,
            right: 10,
            child: SizedBox(
              width: double.maxFinite,
              child: Align(
                alignment: Alignment.center,
                child: Text("Daxil Ol",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width / 10,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomShadowContainer(
                    child: CustomTextFieldWidget(
                      controller: usernameController,
                      hintText: "İstifadəçi adı",
                      prefixIcon: null,
                    ),
                  ),
                  SizedBox(height: distanceBetweenWidget),
                  CustomShadowContainer(
                    child: CustomPasswordTextFieldWidget(
                      controller: passwordController,
                      passwordInvisible: !_passwordVisible,
                      labelText: "Parol",
                      onSuffixPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: distanceBetweenWidget),
                  LogInButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      onPressed();
                    },
                    isLoading: isLoading,
                  ),
                  SizedBox(
                    height: distanceBetweenWidget / 2,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Şifrənizi unutduz?",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocListener<LogInCubit, LogInCubitStates>(
            listener: (context, state) {
              if (state is LogInUsernamePasswordWrongState) {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                ));
              } else if (state is LogInLoggedInState) {
                setState(() {
                  isLoading = false;
                });
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(providers: [
                            BlocProvider(
                              lazy: false,
                              create: (BuildContext context) => HomeCubits(),
                            ),
                            BlocProvider(
                              lazy: false,
                              create: (BuildContext context) =>
                                  ChatPageCubit()..start(context),
                            ),
                            BlocProvider(
                              lazy: false,
                              create: (BuildContext context) =>
                                  NotificationCubit()..start(context),
                            ),
                          ], child: const Home())),
                  (Route<dynamic> route) => false,
                );
              }
            },
            child: Container(),
          )
        ],
      ),
    );
  }
}
