import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_cubit.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Constants.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({super.key});

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  File? _image;
  late TextEditingController teamNameController;
  late TextEditingController teamDescriptionController;
  late TextEditingController phoneNumberController;
  String phoneNumber = "";

  bool phoneNumberValidated = false;

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery); // Use ImageSource.camera for the camera

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage
            .path); // Create a File object using the picked image path
      }
    });
  }

  bool isPrivate = false;

  void getPhoneNumber() async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var phoneNumberUser = sharedPreferences.getString(phoneNumberKey);
    var test =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumberUser ?? "");
    if (phoneNumberUser != null) {
      phoneNumberValidated = true;
    }
    setState(() {
      var number = phoneNumberUser ?? "";
      var newNumber = number.replaceAll("+${test.dialCode}", "").trim();
      print(newNumber);
      phoneNumberController.text = newNumber;
    });
    print("Testtt ${test}");
  }

  void changeState(bool isPrivate) {
    setState(() {
      this.isPrivate = isPrivate;
    });
  }

  void onTap() {
    print(phoneNumberController.text);
    print(teamNameController.text);
    print(teamDescriptionController.text);
  }

  @override
  void initState() {
    super.initState();
    teamNameController = TextEditingController();
    teamDescriptionController = TextEditingController();
    phoneNumberController = TextEditingController();
    getPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: double.maxFinite,
        height: height,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: height / 40,
            ),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color(blackColor3),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _image == null
                        ? Icon(
                            Icons.shield,
                            size: width / 3,
                            color: Colors.grey,
                          )
                        : ClipRect(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _image!,
                                height: width / 3,
                                width: width / 3,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(blackColor2)),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.mode_edit_outlined,
                          color: Color(goldColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 40,
            ),
            Container(
              width: width / 2,
              decoration: BoxDecoration(
                  color: const Color(blackColor3),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    // Background color of the container
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: teamNameController,
                    maxLength: 25,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(blackColor3),
                      labelText: "Komanda adı",
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
              ),
            ),
            SizedBox(
              height: height / 80,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(children: [
                  TextSpan(
                      text: "Diqqət!!! ",
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                  TextSpan(
                    text: "Komanda adı ayda cəmi 1 dəfə dəyişdirilə  bilər!",
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: height / 80,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(blackColor3),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: height / 8,
                    decoration: const BoxDecoration(
                      color: Color(blackColor3),
                    ),
                    child: TextField(
                      textAlign: TextAlign.start,
                      controller: teamDescriptionController,
                      expands: true,
                      maxLength: 100,
                      minLines: null,
                      maxLines: null,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(blackColor3),
                        labelText: "Komanda təsviri",
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
                ),
              ),
            ),
            SizedBox(
              height: height / 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(blackColor3),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InternationalPhoneNumberInput(
                    initialValue: PhoneNumber(isoCode: "AZ"),
                    onInputChanged: (PhoneNumber phoneNumber) {
                      // Handle phone number input changes
                      print(phoneNumber.phoneNumber);
                      this.phoneNumber = phoneNumber.phoneNumber ?? "";
                    },
                    onInputValidated: (bool value) {
                      print(value);
                      phoneNumberValidated = value;
                    },
                    selectorTextStyle: const TextStyle(
                      color: Colors.white, // Set the color to white
                    ),
                    textStyle: const TextStyle(color: Colors.white),
                    inputDecoration: const InputDecoration(
                      labelText: 'Telefon Nömrəsi',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(blackColor3))),
                    ),
                    textFieldController: phoneNumberController,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: !isPrivate
                            ? const Color(blackColor2)
                            : const Color(goldColor)),
                    onPressed: () {
                      changeState(true);
                    },
                    child: Center(
                      child: Text(
                        "Qapalı",
                        style: TextStyle(
                            color: !isPrivate
                                ? const Color(goldColor)
                                : Colors.black,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: !isPrivate
                            ? const Color(goldColor)
                            : const Color(blackColor2)),
                    onPressed: () {
                      changeState(false);
                    },
                    child: Center(
                      child: Text(
                        "Açıq",
                        style: TextStyle(
                            color: !isPrivate
                                ? Colors.black
                                : const Color(goldColor),
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(children: [
                  TextSpan(
                      text: "Diqqət!!! ",
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                  TextSpan(
                    text:
                        "Qapalı komandaya birbaşa daxil olmaq olmur, ancaq sorğu ilə daxil olmaq olur!",
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: width / 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(goldColor)),
                  onPressed: () {
                    if (teamNameController.text.trim().isNotEmpty &&
                        teamDescriptionController.text.trim().isNotEmpty &&
                        phoneNumberController.text.trim().isNotEmpty) {
                      if (phoneNumberValidated) {
                        context.read<TeamDetailCubit>().createTeam(
                            teamNameController.text,
                            teamDescriptionController.text,
                            _image,
                            phoneNumber,
                            isPrivate);
                      } else {
                        showCustomSnackbar(
                            context, "Telefon nömrəsini düzgün daxil edin");
                      }
                    } else {
                      showCustomSnackbar(context, "Məlumatları tam daxil edin");
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Yarat",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
