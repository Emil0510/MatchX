import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants.dart';
import '../team_cubit/team_cubit.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int _minRankValue = 100;
  int _maxRankValue = 3500;
  RangeValues _selectedRankRange = const RangeValues(100, 3500);
  int _minMemberValue = 1;
  int _maxMemberValue = 11;
  RangeValues _selectedMemberRange = const RangeValues(1, 11);
  String selectedSort = 'Default';
  int selectedSortInt = 0; // Default selected value
  List<String> sortOptions = [
    'Default',
    'A-Z',
    'Ən populyar',
    'Yeni',
    'Köhnə'
    // Add more options as needed
  ];

  String selectedDivision = 'Hamısı';

  int selectedDivisionInt = 0; // Default selected value
  List<String> divisionOptions = [
    'Hamısı',
    'Həvəskar 2',
    'Həvəskar 1',
    'Diviziya 3',
    'Diviziya 2',
    'Diviziya 1',
    'Super Liq',
    // Add more options as needed
  ];

  bool? isPrivate;
  String selectedPrivate = "Hamısı";
  List<String> privateOptions = ["Hamısı", "Açıq", "Qapalı"];

  void changeState(bool isPrivate) {
    setState(() {
      this.isPrivate = isPrivate;
    });
  }

  void onResetTapped() {
    setState(() {
      _minRankValue = 100;
      _maxRankValue = 3500;
      _selectedRankRange = const RangeValues(100, 3500);
      // Convert the selected values to integers
      _selectedRankRange = RangeValues(
        _selectedRankRange.start.roundToDouble(),
        _selectedRankRange.end.roundToDouble(),
      );
      _minMemberValue = 1;
      _maxMemberValue = 11;
      _selectedMemberRange = const RangeValues(1, 11);
      // Convert the selected values to integers
      _selectedMemberRange = RangeValues(
        _selectedMemberRange.start.roundToDouble(),
        _selectedMemberRange.end.roundToDouble(),
      );
      selectedSort = 'Default';
      selectedDivision = 'All';
      selectedSortInt = 0;
      selectedDivisionInt = 0;
      isPrivate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(18, 17, 17, 1)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: const Icon(
                Icons.drag_handle,
                size: 40.0,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              "Rank",
                              style: TextStyle(
                                  color: Color(goldColor),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          RangeSlider(
                            values: _selectedRankRange,
                            activeColor: Color(goldColor),
                            min: _minRankValue.toDouble(),
                            max: _maxRankValue.toDouble(),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _selectedRankRange = values;
                                // Convert the selected values to integers
                                _selectedRankRange = RangeValues(
                                  _selectedRankRange.start.roundToDouble(),
                                  _selectedRankRange.end.roundToDouble(),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      Text(
                        'Rank: ${_selectedRankRange.start.toInt()} - ${_selectedRankRange.end.toInt()}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // You can use the selected range for filtering search results.
            // Add your search result display logic here.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              "Üzv sayı",
                              style: TextStyle(
                                  color: Color(goldColor),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          RangeSlider(
                            values: _selectedMemberRange,
                            activeColor: Color(goldColor),
                            min: _minMemberValue.toDouble(),
                            max: _maxMemberValue.toDouble(),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _selectedMemberRange = values;
                                // Convert the selected values to integers
                                _selectedMemberRange = RangeValues(
                                  _selectedMemberRange.start.roundToDouble(),
                                  _selectedMemberRange.end.roundToDouble(),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      Text(
                        'Üzv sayı: ${_selectedMemberRange.start.toInt()} - ${_selectedMemberRange.end.toInt()}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sort",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                width: double.maxFinite,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedSort,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSort = newValue!;
                                      selectedSortInt =
                                          sortOptions.indexOf(newValue);
                                    });
                                  },
                                  dropdownColor: Colors.black,
                                  items: sortOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style:
                                            TextStyle(color: Color(goldColor)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Diviziya",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.start,
                              ),
                              Container(
                                width: double.maxFinite,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedDivision,
                                  hint: Text('Division'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedDivision = newValue!;
                                      selectedDivisionInt =
                                          divisionOptions.indexOf(newValue);
                                    });
                                  },
                                  dropdownColor: Colors.black,
                                  items: divisionOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style:
                                            TextStyle(color: Color(goldColor)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Komanda Tipi",
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.start,
                      ),
                      Container(
                        width: double.maxFinite,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedPrivate,
                          hint: Text('Komanda Tipi'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPrivate = newValue!;
                              if(privateOptions.indexOf(newValue) == 0){
                                isPrivate = null;
                              }else if(privateOptions.indexOf(newValue) == 1){
                                isPrivate = false;
                              }else if(privateOptions.indexOf(newValue) == 2){
                                isPrivate = true;
                              }
                            });
                          },
                          dropdownColor: Colors.black,
                          items: privateOptions
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                    TextStyle(color: Color(goldColor)),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width / 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: onResetTapped,
                      child: const Center(
                        child: Text(
                          "Sıfırla",
                          style:
                              TextStyle(color: Color(goldColor), fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width / 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(goldColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<TeamCubit>().loadWithFilter(
                            _selectedRankRange.start.toInt(),
                            _selectedRankRange.end.toInt(),
                            isPrivate,
                            _selectedMemberRange.start.toInt(),
                            _selectedMemberRange.end.toInt(),
                            selectedSortInt,
                            selectedDivisionInt,
                            1);
                      },
                      child: const Center(
                        child: Text(
                          "Saxla",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height / 30)
          ]),
    );
  }
}
