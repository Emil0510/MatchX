import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/home/matches_page/create_match_page/create_match_cubit/create_match_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateMatchCubit extends Cubit<CreateMatchStates> {
  CreateMatchCubit() : super(CreateMatchInitialState());

  start() {
    emit(CreateMatchesPageState(isError: false, message: ""));
  }

  startCreateWithLink() {
    emit(CreateMatchesWithLinkPageState(guide: "", isSuccesfull: true, message: "first"));
  }

  createGame(bool isRated, DateTime dateTime1, String message, int region) async {
    emit(CreateMatchLoadingState());
    print("object");
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    DateTime newDate = DateTime(
        dateTime1.year, dateTime1.month, dateTime1.day, dateTime1.hour, 0);

    print(newDate.toString());

    Map<String, dynamic>? paramters = {"IsRated": isRated, "GameDate": newDate.toString(), "Region" : region, "Message" : message};

    var formData = FormData.fromMap(paramters);

    try {
      var response = await dio.post(baseUrl + gameCreateApi,
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }, contentType: 'application/json'),
          data: formData);

      print(response.data);
      if (response.statusCode == 200) {
        emit(CreateMatchesPageState(isError: true, message: "Oyun yaradıldı"));
      } else {
        emit(CreateMatchesPageState(isError: true, message: ""));
      }
    } on DioException catch (e) {
      print(e.response?.data);
      emit(CreateMatchesPageState(isError: true, message: e.response?.data['message']));
    }
  }

  createLinkGame(bool isRated, String dateTime, int region, String message) async {
    emit(CreateMatchLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);



    DateTime date = DateTime.parse(dateTime);
    DateTime newDate = DateTime(date.year, date.month, date.day,date.hour, 0);

    var time = newDate.toString();

    print(time);


    Map<String, dynamic> body = {"isRated": isRated, "gameDate": time, "region" : region, "message" : message};


    var formData = FormData.fromMap(body);

    try {
      var response = await dio.post(
        baseUrl + gameCreateLinkApi,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        data: formData,
       );


      if (response.statusCode == 200) {
        print(response.data);
        emit(CreateMatchesWithLinkPageState(guide: response.data['data'], isSuccesfull: true, message: 'Yaradildi'));
      } else {
        emit(CreateMatchesWithLinkPageState(guide: "", isSuccesfull: false, message: "Səhvlik"));
      }
    } on DioException catch (e) {
      print(e.response?.data);
      emit(CreateMatchesWithLinkPageState(guide: "", isSuccesfull: false, message: e.response?.data['message']));
    }
  }
}
