import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/network/model/User.dart';
import 'package:flutter_app/pages/home/more_page/ui/widget/input_text_field.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/widgets/buttons_widgets.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../Constants.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController phoneNumberController;
  bool phoneNumberValidated = false;
  String phoneNumber = "";

  bool isLoading = false;

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

  late DateTime selectedDate; // Default value for the selected date

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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    nameController.text = widget.user.name;
    surnameController.text = widget.user.surName ?? "";
    selectedDate = DateTime.parse(widget.user.dateOfBirth ?? "");
    phoneNumberController = TextEditingController();
    if ((widget.user.phoneNumber ?? "").isNotEmpty) {
      print(widget.user.phoneNumber);
      phoneNumberValidated = true;
      getPhoneNumber();
    }
  }

  void getPhoneNumber() async {
    var test = await PhoneNumber.getRegionInfoFromPhoneNumber(
        widget.user.phoneNumber ?? "");
    setState(() {
      var number = widget.user.phoneNumber ?? "";
      var newNumber = number.replaceAll("+${test.dialCode}", "").trim();
      print(newNumber);
      phoneNumberController.text = newNumber;
    });
    print("Testtt ${test}");
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
                          mainAxisSize: MainAxisSize.min,
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
                                controller: nameController,
                                text: "Ad",
                                onSufficsTap: () {
                                },
                                passwordVisible: true,
                                iconVisibility: false,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MorePageTextField(
                                controller: surnameController,
                                text: "Soyad",
                                onSufficsTap: () {
                                },
                                passwordVisible: true,
                                iconVisibility: false,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InternationalPhoneNumberInput(
                                initialValue: PhoneNumber(isoCode: "AZ"),
                                onInputChanged: (PhoneNumber phoneNumber) {
                                  // Handle phone number input changes
                                  print(phoneNumber.phoneNumber);
                                  this.phoneNumber =
                                      phoneNumber.phoneNumber ?? "";
                                },
                                onInputValidated: (bool value) {
                                  // Handle validation
                                  print(value);
                                  phoneNumberValidated = value;
                                },
                                selectorTextStyle: const TextStyle(
                                  color: Colors.white, // Set the color to white
                                ),
                                textStyle: const TextStyle(color: Colors.white),
                                inputDecoration: const InputDecoration(
                                  labelText: 'Telefon nömrəsi',
                                  labelStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(),
                                ),
                                textFieldController: phoneNumberController,
                              ),
                            ),
                            SizedBox(
                              height: height / 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: height / 25,
                                decoration: const BoxDecoration(
                                  color: Color(blackColor3),
                                  // Background color of the container
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black38,
                                      // Shadow color
                                      offset: Offset(0, 4),
                                      // Offset of the shadow (x, y)
                                      blurRadius: 6,
                                      // Spread of the shadow
                                      spreadRadius:
                                          0, // Expansion of the shadow
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: width,
                                  child: ElevatedButton(
                                    onPressed: () => _selectDate(context),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(blackColor3),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    child: Text(
                                      "Doğum tarixi: ${"${selectedDate.toLocal()}".split(' ')[0]}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(width / 10),
                              child: CustomLoadingButton(
                                  onPressed: () {
                                    if (nameController.text.trim().isNotEmpty &&
                                        surnameController.text
                                            .trim()
                                            .isNotEmpty) {
                                      if (isLoading == false) {
                                        if (phoneNumberController.text
                                            .trim()
                                            .isNotEmpty) {
                                          if (phoneNumberValidated) {
                                            print("Phne number ${phoneNumber}");
                                            setState(() {
                                              isLoading = true;
                                            });
                                            context
                                                .read<OptionsCubit>()
                                                .saveEditProfile(
                                                    nameController.text,
                                                    surnameController.text,
                                                    _image,
                                                    selectedDate,
                                                    phoneNumber,
                                                    (isSuccesfull, message) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              if (isSuccesfull) {
                                                Navigator.of(context).pop();
                                                showCustomSnackbar(
                                                    context, message);
                                              } else {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                showCustomSnackbar(
                                                    context, message);
                                              }
                                            });
                                          } else {
                                            showCustomSnackbar(context,
                                                "Telefon nömrəsini düzgün daxil edin");
                                          }
                                        } else {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          context
                                              .read<OptionsCubit>()
                                              .saveEditProfile(
                                                  nameController.text,
                                                  surnameController.text,
                                                  _image,
                                                  selectedDate,
                                                  phoneNumber,
                                                  (isSuccesfull, message) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            if (isSuccesfull) {
                                              Navigator.pop(context, true);
                                              showCustomSnackbar(
                                                  context, message);
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              showCustomSnackbar(
                                                  context, message);
                                            }
                                          });
                                        }
                                      }
                                    } else {
                                      showCustomSnackbar(context,
                                          "Ad və soyadı tam daxil edin");
                                    }
                                  },
                                  isLoading: isLoading,
                                  text: "Saxla",
                                  color: Color(goldColor),
                                  textColor: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: heightDistance - imageSize / 2 - height / 30,
                      child: _image == null
                          ? Stack(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    widget.user.profilePhotoUrl,
                                    height: imageSize,
                                    width: imageSize,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _getImage,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(goldColor),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.mode_edit_outlined,
                                          color: Color(blackColor3),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Stack(
                              children: [
                                ClipOval(
                                  child: Image.file(
                                    _image!,
                                    height: imageSize,
                                    width: imageSize,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _getImage,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(goldColor),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.mode_edit_outlined,
                                          color: Color(blackColor3),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
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
