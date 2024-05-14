import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Constants.dart';

class SuggestionAndCommentPage extends StatefulWidget {
  const SuggestionAndCommentPage({super.key});

  @override
  State<SuggestionAndCommentPage> createState() =>
      _SuggestionAndCommentPageState();
}

class _SuggestionAndCommentPageState extends State<SuggestionAndCommentPage> {
  List<String> suggesetion = ["Təklifdir", "İraddır"];
  String selected = "Təklifdir";
  bool isSuggestion = true;
  late TextEditingController descriptionController;

  File? _image; // Variable to store the selected image

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Təklif və İradlarınız",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: height,
          width: width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: height / 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                GestureDetector(
                  onTap: _getImage,
                  child: _image == null
                      ? Icon(
                    Icons.image,
                    size: width / 3,
                    color: Colors.grey,
                  )
                      : ClipRRect(
                    child: Image.file(
                      _image!,
                      height: width / 3,
                      width: width / 3,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(
                //     onPressed: _getImage,
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color(goldColor)),
                //     child: const Text(
                //       'Şəkil əlavə et',
                //       style: TextStyle(color: Colors.black),
                //     ),
                //   ),
                // ),
              ),
              Text("Mesajınızla bağlı təsvir daxil edə bilərsiniz"),
              SizedBox(
                height: height / 30,
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
                      height: height / 5,
                      decoration: const BoxDecoration(
                        color: Color(blackColor3),
                      ),
                      child: TextField(
                        textAlign: TextAlign.start,
                        controller: descriptionController,
                        expands: true,
                        maxLength: 300,
                        minLines: null,
                        maxLines: null,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(blackColor3),
                          labelText: "Təsvir",
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(blackColor2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(blackColor2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(blackColor2)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 25,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(blackColor2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: width / 3,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selected,
                      onChanged: (String? newValue) {
                        setState(() {
                          selected = newValue!;
                          isSuggestion = suggesetion.indexOf(newValue) == 0;
                        });
                      },
                      dropdownColor: Color(blackColor2),
                      items: suggesetion
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Color(goldColor)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: height / 15,
              ),
              ElevatedButton(
                onPressed: () {
                  if (descriptionController.text.trim().isNotEmpty) {
                    context.read<OptionsCubit>().sendSuggestion(isSuggestion,
                        descriptionController.text.trim(), _image);
                  } else {
                    showCustomSnackbar(
                        context, "Xaiş olunur təsviri daxil edin");
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(goldColor)),
                child: const Text(
                  'Göndər',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
