import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/home/matches_page/create_match_page/create_match_cubit/create_match_cubit.dart';
import 'package:flutter_app/widgets/input_text_widgets.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../Constants.dart';

class CreateMatchWithLink extends StatefulWidget {
  final String guide;

  const CreateMatchWithLink({super.key, required this.guide});

  @override
  State<CreateMatchWithLink> createState() => _CreateMatchWithLinkState();
}

class _CreateMatchWithLinkState extends State<CreateMatchWithLink> {
  DateTime selectedDate = DateTime.now();
  bool isRated = true;
  late TextEditingController controller;

  TextEditingController messageController = TextEditingController();
  String selectedRegion = 'Bakı';
  int selectedRegionId = 7;

  dateTimePickerWidget(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime.now(),
      maxDateTime: DateTime.now().add(Duration(days: 30)),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        DateTime selectdate = dateTime;
        final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
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
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.text = widget.guide;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        color: Colors.transparent,
        child: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: height / 50,
                ),
                const Text(
                  "Link ilə oyun yarat",
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: height / 50,
                ),
                widget.guide.trim().isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CustomReadOnlyText(controller: controller),
                      )
                    : Column(
                        children: [
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
                                  backgroundColor: isRated
                                      ? const Color(goldColor)
                                      : Colors.black),
                              onPressed: () {
                                changeState();
                              },
                              child: Center(
                                child: Text(
                                  isRated ? "Bəli" : "Xeyr",
                                  style: TextStyle(
                                      color: isRated
                                          ? Colors.black
                                          : const Color(goldColor),
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
                                  color: Colors.black38,
                                  // Shadow color
                                  offset: Offset(0, 4),
                                  // Offset of the shadow (x, y)
                                  blurRadius: 6,
                                  // Spread of the shadow
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
                            child: Container(
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
                                    print(selectedRegionId);
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
                        ],
                      ),
                SizedBox(
                  height: height / 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (widget.guide.trim().isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: controller.text));
                      showToastMessage(context, "Kopyalandı");
                    } else {
                      context
                          .read<CreateMatchCubit>()
                          .createLinkGame(isRated, selectedDate.toString(), selectedRegionId, messageController.text.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(goldColor)),
                  child: Text(
                    widget.guide.trim().isNotEmpty ? "Kopyala" : "Link ilə oyun yarat",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: height / 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
