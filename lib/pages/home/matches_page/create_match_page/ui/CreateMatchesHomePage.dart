import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/pages/home/matches_page/create_match_page/create_match_cubit/create_match_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

class CreateMatchesHomePage extends StatefulWidget {
  const CreateMatchesHomePage({super.key});

  @override
  State<CreateMatchesHomePage> createState() => _CreateMatchesHomePageState();
}

class _CreateMatchesHomePageState extends State<CreateMatchesHomePage> {
  bool isRated = true;
  DateTime selectedDate = DateTime.now();
  TextEditingController messageController = TextEditingController();
  String selectedRegion = 'Bakı';
  int selectedRegionId = 7;


  dateTimePickerWidget(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime.now(),
      maxDateTime: DateTime.now().add(const Duration(days: 30)),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        DateTime selectdate = dateTime;
        setState(() {
          selectedDate = selectdate;
        });
      },
    );
  }

  void changeState() {
    setState(() {
      isRated = !isRated;
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
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height / 50,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  child: Text(
                    "Oyun Yarat",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: height / 50,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  child: Text(
                    "Reytingli oyundurmu?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(
                width: width * 2 / 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isRated ? const Color(goldColor) : Colors.black),
                  onPressed: () {
                    changeState();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Center(
                    child: Text(
                      isRated ? "Bəli" : "Xeyr",
                      style: TextStyle(
                          color: isRated ? Colors.black : const Color(goldColor),
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              Container(
                width: width * 2 / 3,
                decoration: const BoxDecoration(
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
                  onPressed: () => dateTimePickerWidget(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(goldColor)),
                  child: Text(
                    "Tarix: ${"${selectedDate.toLocal()}".split(' ')[0]} ${selectedDate.hour}:00",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  width: 2 * width / 3,
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      fillColor: const Color(blackColor3),
                      filled: true,
                      labelText: "Mesaj",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xFF888888),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: width/1.5,
                  decoration: BoxDecoration(
                      color: const Color(blackColor2),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedRegion,
                    hint: const Text('Region'),
                    menuMaxHeight: height / 2,
                    alignment: Alignment.bottomCenter,
                    underline: const SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRegion = newValue!;
                        selectedRegionId = regionsConstants.indexOf(newValue);
                      });
                    },
                    dropdownColor: Colors.black,
                    items: regionsConstants
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value,
                            style: const TextStyle(color: Color(goldColor)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: height / 20,
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<CreateMatchCubit>()
                      .createGame(isRated, selectedDate, messageController.text.trim(), selectedRegionId);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(goldColor)),
                child: const Text(
                  "Oyun yarat",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: height / 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
