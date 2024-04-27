import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../Constants.dart';
import '../../../network/network.dart';

class CreateAccount extends StatefulWidget {
  final Function toLogIn;

  const CreateAccount({super.key, required this.toLogIn});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  late TextEditingController usernameController;
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController emailAddressController;
  late TextEditingController pinController;
  late bool _passwordVisible;
  late double distanceBetweenWidget;

  var step = 0;
  var isBackBtnVisible = false;
  var isPinEnabled = true;

  late WebViewController webViewController;
  var nextButtonText = "Irəli";

  late Widget createAccount;
  late Widget userInfo;
  late Widget addPhoto;
  late Widget verifyEmail;
  late Set<Widget> sign_up_stages;

  bool isLoading = false;

  late List<bool> iconSelectors;

  DateTime selectedDate = DateTime.now(); // Default value for the selected date

  void toLogIn() {}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900), // Adjust the start date as needed
      lastDate: DateTime.now(), // Adjust the end date as needed
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  File? _image; // Variable to store the selected image

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery); // Use ImageSource.camera for the camera

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        // Create a File object using the picked image path
      }
    });
  }

  void skip() {
    setState(() {
      isBackBtnVisible = true;
      step++;
      currentStep++;
    });
  }

  void onNextPressed() {
    if (step == 0) {
      checkExistence();
    } else if (step == 1) {
      checkNameAndSurname();
    } else if (step == 2) {
      registerUser();
    } else {
      setState(() {
        if (step != 3) {
          iconSelectors[step] = true;
          isBackBtnVisible = true;
          step++;
          currentStep++;
        } else {
          // checkVerificationCode();
        }
      });
    }
  }

  void onBackPressed() {
    setState(() {
      if (step != 0) {
        isLoading = false;
        nextButtonText = "Irəli";
        step--;
        iconSelectors[step] = false;
        currentStep--;
        if (step == 0) {
          isBackBtnVisible = false;
        }
      }
    });
  }

  void checkExistence() {
    if (!isLoading) {
      RegExp regEx = RegExp(r"(?=.*[a-z])(?=.*[A-Z])\w+");
      RegExp mailRegEx = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      if (usernameController.text.trim().isEmpty ||
          emailAddressController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty ||
          confirmPasswordController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Xaiş olunur məlumatları tam daxil edin"),
        ));
      } else {
        if (usernameController.text.trim().length < 4 ||
            usernameController.text.trim().contains("@") ||
            usernameController.text.trim().length > 16) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Istifadəçi adı minimum 4 maximum 16 hərfdən ibarət olmalıdır və '@' işarəsi ola bilməz"),
          ));
        } else {
          if (mailRegEx.hasMatch(emailAddressController.text.trim())) {
            if (passwordController.text.trim() !=
                confirmPasswordController.text.trim()) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Parollar bir biri ilə üst üstə gəlmir"),
              ));
            } else {
              setState(() {
                isLoading = true;
              });
              if (passwordController.text.trim().length >= 8 &&
                  regEx.hasMatch(passwordController.text.trim())) {
                checkExistenceOfUser(emailAddressController.text.trim(),
                        usernameController.text.trim())
                    .then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  if (value.canSignUp) {
                    setState(() {
                      if (step != 3) {
                        iconSelectors[step] = true;
                        isBackBtnVisible = true;
                        step++;
                        currentStep++;
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "İstifadəçi adı və ya email artıq istifadə olunub"),
                    ));
                  }
                }).catchError((onError) {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Parol minimum 8 hərfdən ibartə olmalıdı, 1 böyük və 1 balaca hərf"),
                ));
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Mail adresi səhv daxil edilib"),
            ));
          }
        }
      }
    }
  }

  void registerUser() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      registerUserApi(
              nameController.text,
              surnameController.text,
              usernameController.text,
              emailAddressController.text,
              passwordController.text,
              _image,
              "",
              "${selectedDate.toLocal()}".split(' ')[0])
          .then((value) {
        setState(() {
          isLoading = false;
        });

        if (value.canSignUp) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Mailinizə qeydiyyat təsdiqi göndərildi!"),
          ));
          widget.toLogIn();
          // setState(() {
          //   nextButtonText = "Təsdiqlə";
          //   iconSelectors[step] = true;
          //   isBackBtnVisible = true;
          //   step++;
          //   currentStep++;
          // });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Xəta baş verdi"),
          ));
        }
      }).catchError((onError) {});
    }
  }

  // void checkVerificationCode() {
  //   if (pinController.text.length < 6) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Kodu tam daxil edin"),
  //     ));
  //   } else {
  //     verifyEmailApi(emailAddressController.text, pinController.text)
  //         .then((value) {
  //       if (value.canSignUp) {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text("Uğurla qeydiyyatdan keçdiniz"),
  //         ));
  //         widget.toLogIn();
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text("Kod səhvdir"),
  //         ));
  //       }
  //     }).catchError((onError) {});
  //   }
  // }

  void checkNameAndSurname() {
    if (nameController.text.trim().isEmpty ||
        surnameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Xaiş olunur məlumatları tam daxil edin"),
      ));
    } else {
      setState(() {
        if (step != 3) {
          nextButtonText = "Təsdiqlə";
          iconSelectors[step] = true;
          isBackBtnVisible = true;
          step++;
          currentStep++;
        }
      });
    }
  }

  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    emailAddressController = TextEditingController();
    confirmPasswordController = TextEditingController();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    pinController = TextEditingController();
    _passwordVisible = false;
    iconSelectors = [false, false, false, false];

    sign_up_stages = Set();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    emailAddressController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    pinController.dispose();
    super.dispose();
  }

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var containerHeight = height;
    distanceBetweenWidget = height / 30;

    createAccount = Container(
      key: const ValueKey(1),
      height: containerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child:   SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints:
                  BoxConstraints(maxHeight: height / 10, minHeight: height / 15),
              decoration: const BoxDecoration(
                color: Color(blackColor),
                // Background color of the container
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38, // Shadow color
                    offset: Offset(0, 4), // Offset of the shadow (x, y)
                    blurRadius: 6, // Spread of the shadow
                    spreadRadius: 0, // Expansion of the shadow
                  ),
                ],
              ),
              child: TextField(
                controller: usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(blackColor),
                  labelText: "İstifadəçi adı",
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenWidget,
            ),
            Container(
              constraints:
                  BoxConstraints(maxHeight: height / 10, minHeight: height / 15),
              decoration: const BoxDecoration(
                color: Color(blackColor),
                // Background color of the container
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38, // Shadow color
                    offset: Offset(0, 4), // Offset of the shadow (x, y)
                    blurRadius: 6, // Spread of the shadow
                    spreadRadius: 0, // Expansion of the shadow
                  ),
                ],
              ),
              child: TextField(
                controller: emailAddressController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(blackColor),
                  labelText: "E-mail adresi",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenWidget,
            ),
           Container(
                constraints: BoxConstraints(
                    maxHeight: height / 10, minHeight: height / 15),
                decoration: const BoxDecoration(
                  color: Color(blackColor),
                  // Background color of the container
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38, // Shadow color
                      offset: Offset(0, 4), // Offset of the shadow (x, y)
                      blurRadius: 6, // Spread of
                      // the shadow
                      spreadRadius: 0, // Expansion of the shadow
                    ),
                  ],
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: !(_passwordVisible),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(blackColor),
                    labelText: 'Parol',
                    labelStyle: TextStyle(color: Colors.grey),
                    // Here is key idea
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
            SizedBox(
              height: distanceBetweenWidget,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                constraints:
                    BoxConstraints(maxHeight: height / 10, minHeight: height / 15),
                decoration: const BoxDecoration(
                  color: Color(blackColor),
                  // Background color of the container
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38, // Shadow color
                      offset: Offset(0, 4), // Offset of the shadow (x, y)
                      blurRadius: 6, // Spread of the shadow
                      spreadRadius: 0, // Expansion of the shadow
                    ),
                  ],
                ),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: !(_passwordVisible),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(blackColor),
                    labelText: 'Parolu təsdiqlə',
                    labelStyle: TextStyle(color: Colors.grey),
                    // Here is key idea
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xff888888),
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    userInfo = Container(
      key: const ValueKey(2),
      height: containerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: distanceBetweenWidget,
          ),
          Container(
            constraints:
                BoxConstraints(maxHeight: height / 10, minHeight: height / 15),
            decoration: const BoxDecoration(
              color: Color(blackColor),
              // Background color of the container
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38, // Shadow color
                  offset: Offset(0, 4), // Offset of the shadow (x, y)
                  blurRadius: 6, // Spread of the shadow
                  spreadRadius: 0, // Expansion of the shadow
                ),
              ],
            ),
            child: TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(blackColor),
                labelText: "Ad",
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: distanceBetweenWidget,
          ),
          Container(
            constraints:
                BoxConstraints(maxHeight: height / 10, minHeight: height / 15),
            decoration: const BoxDecoration(
              color: Color(blackColor),
              // Background color of the container
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38, // Shadow color
                  offset: Offset(0, 4), // Offset of the shadow (x, y)
                  blurRadius: 6, // Spread of the shadow
                  spreadRadius: 0, // Expansion of the shadow
                ),
              ],
            ),
            child: TextField(
              controller: surnameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(blackColor),
                labelText: "Soyad",
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: distanceBetweenWidget,
          ),
          Container(
            height: height / 25,
            width: width - 20,
            decoration: const BoxDecoration(
              color: Color(blackColor),
              // Background color of the container
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38, // Shadow color
                  offset: Offset(0, 4), // Offset of the shadow (x, y)
                  blurRadius: 6, // Spread of the shadow
                  spreadRadius: 0, // Expansion of the shadow
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(goldColor)),
              child: Text(
                "Doğum tarixi: ${"${selectedDate.toLocal()}".split(' ')[0]}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
    addPhoto = SizedBox(
      key: const ValueKey(3),
      height: containerHeight,
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: distanceBetweenWidget,
          ),
          _image == null
              ? const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey,
                )
              : ClipOval(
                  child: Image.file(
                    _image!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: _getImage,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(goldColor)),
            child: const Text(
              'Şəkil əlavə et',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );

    sign_up_stages.clear();
    sign_up_stages.add(createAccount);
    sign_up_stages.add(userInfo);
    sign_up_stages.add(addPhoto);

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: height - containerHeight,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              var tween = Tween(begin: begin, end: end);
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: height/8,),
                  Text(
                    "Qeydiyyatdan Keç",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width / 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height/10,),
                  Container(
                    color: Colors.black,
                    child: sign_up_stages.elementAt(step),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: height / 8,
          left: 10,
          right: 10,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: isBackBtnVisible,
                child: Container(
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Color(blackColor),
                    // Background color of the container
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38, // Shadow color
                        offset: Offset(0, 4), // Offset of the shadow (x, y)
                        blurRadius: 6, // Spread of the shadow
                        spreadRadius: 0, // Expansion of the shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(goldColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                      ),
                    ),
                    onPressed: onBackPressed,
                    child: const Center(
                      child: Text(
                        "Geri",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Color(blackColor),
                    // Background color of the container
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38, // Shadow color
                        offset: Offset(0, 4), // Offset of the shadow (x, y)
                        blurRadius: 6, // Spread of the shadow
                        spreadRadius: 0, // Expansion of the shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(goldColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                      ),
                    ),
                    onPressed: onNextPressed,
                    child: Center(
                      child: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 4,
                              ),
                            )
                          : Text(
                              nextButtonText,
                              style:
                                  const TextStyle(color: Colors.black, fontSize: 18),
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
