import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Constants.dart';
import '../../../../network/model/Team.dart';
import '../../../../widgets/snackbar.dart';

class TeamEditPage extends StatefulWidget {
  final Team? team;

  const TeamEditPage({super.key, required this.team});

  @override
  State<TeamEditPage> createState() => _TeamEditPageState();
}

class _TeamEditPageState extends State<TeamEditPage> {
  File? _image;
  late TextEditingController teamNameController;
  late TextEditingController teamDescriptionController;

  bool isButtonEnabled = false;

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery); // Use ImageSource.camera for the camera

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage
            .path); // Create a File object using the picked image path
        isButtonEnabled = true;
      }
    });
  }

  bool isPrivate = false;

  void changeState(bool isPrivate) {
    setState(() {
      this.isPrivate = isPrivate;
    });
  }

  void check() {


    if (_image == null) {
      setState(() {
        isButtonEnabled = (widget.team?.name != teamNameController.text) ||
            (widget.team?.description != teamDescriptionController.text) ||
            (widget.team?.isPrivate != isPrivate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    teamNameController = TextEditingController();
    teamNameController.text = widget.team?.name ?? "";
    teamDescriptionController = TextEditingController();
    teamDescriptionController.text = widget.team?.description ?? "";
    setState(() {
      isPrivate = widget.team?.isPrivate == true;
    });
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
                        ? widget.team?.teamLogoUrl == null
                            ? Icon(
                                Icons.shield,
                                size: width / 3,
                                color: Colors.grey,
                              )
                            : Image.network(
                                widget.team?.teamLogoUrl ?? "",
                                height: width / 3,
                                width: width / 3,
                                fit: BoxFit.cover,
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
                    onChanged: (newText) {
                      check();
                    },
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
                      onChanged: (newText) {
                        check();
                      },
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
                      check();
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
                      check();
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
                  onPressed: isButtonEnabled
                      ? () {
                          if (teamNameController.text.trim().isNotEmpty &&
                              teamDescriptionController.text
                                  .trim()
                                  .isNotEmpty) {
                            //Save Changes
                            context.read<TeamDetailCubit>().editTeam(
                                teamNameController.text,
                                teamDescriptionController.text,
                                _image,
                                isPrivate);
                          } else {
                            showCustomSnackbar(
                                context, "Məlumatları tam daxil edin");
                          }
                        }
                      : null,
                  child: const Center(
                    child: Text(
                      "Saxla",
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
