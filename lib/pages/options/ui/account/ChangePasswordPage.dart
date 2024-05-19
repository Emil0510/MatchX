import 'package:flutter/material.dart';
import 'package:flutter_app/network/model/User.dart';
import 'package:flutter_app/pages/home/more_page/ui/widget/input_text_field.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/widgets/buttons_widgets.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;

  const ChangePasswordPage({super.key, required this.user});

  @override
  State<ChangePasswordPage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ChangePasswordPage> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;

  bool isLoading = false;

  bool _passwordVisible = false;

// Default value for the selected date

  void toLogIn() {}

  @override
  void initState() {
    super.initState();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var heightDistance = height / 5;
    var imageSize = width / 5 * 1.3;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Profili düzənlə",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: Container(
        height: height,
        color: const Color(blackColor2),
        child: SingleChildScrollView(
          child: Container(
            color: const Color(blackColor2),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: imageSize / 2),
                        child: SizedBox(
                          height: heightDistance,
                          width: width,
                          child: Image.asset(
                            "assets/profile_background.jpeg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: heightDistance - height / 30),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(18, 17, 17, 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: imageSize / 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.user.name} ${widget.user.surName ?? ""}",
                                style: TextStyle(fontSize: width / 25),
                              ),
                            ),
                            SizedBox(
                              height: height / 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MorePageTextField(
                                controller: oldPasswordController,
                                text: "Köhnə şifrə",
                                onSufficsTap: () {},
                                passwordVisible: _passwordVisible,
                                iconVisibility: false,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MorePageTextField(
                                controller: newPasswordController,
                                text: "Yeni şifrə",
                                onSufficsTap: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                passwordVisible: _passwordVisible,
                                iconVisibility: true,
                              ),
                            ),
                            SizedBox(
                              height: height / 20,
                            ),
                            Padding(
                              padding: EdgeInsets.all(width / 10),
                              child: CustomLoadingButton(
                                  onPressed: () {
                                    if (oldPasswordController.text
                                            .trim()
                                            .isNotEmpty &&
                                        newPasswordController.text
                                            .trim()
                                            .isNotEmpty) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      context
                                          .read<OptionsCubit>()
                                          .changePassword(
                                        oldPasswordController.text.trim(),
                                        newPasswordController.text.trim(),
                                        widget.user.dateOfBirth ?? "",
                                        (isSuccesfull, message) {
                                          setState(() {
                                            isLoading = false;
                                          });

                                          if (isSuccesfull) {
                                            Navigator.of(context).pop();
                                            showCustomSnackbar(
                                                context, message);
                                          } else {
                                            showCustomSnackbar(
                                                context, message);
                                          }
                                        },
                                      );
                                    } else {
                                      showCustomSnackbar(context,
                                          "Köhnə və yeni parolu daxil edin");
                                    }
                                  },
                                  isLoading: isLoading,
                                  text: "Dəyiş",
                                  color: const Color(goldColor),
                                  textColor: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: heightDistance - imageSize / 2 - height / 30,
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Image.network(
                              widget.user.profilePhotoUrl,
                              height: imageSize,
                              width: imageSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
