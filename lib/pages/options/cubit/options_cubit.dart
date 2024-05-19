import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_app/data.dart';
import 'package:flutter_app/network/model/Question.dart';
import 'package:flutter_app/pages/home/divisions_page/division_cubit/division_cubit.dart';
import 'package:flutter_app/pages/home/home_page/cubit/home_page_cubit.dart';
import 'package:flutter_app/pages/home/matches_page/mathches_cubit/matches_cubit.dart';
import 'package:flutter_app/pages/home/more_page/more_cubit/more_page_cubit.dart';
import 'package:flutter_app/pages/home/team_page/team_cubit/team_cubit.dart';
import 'package:flutter_app/pages/options/cubit/options_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Constants.dart';
import '../../../network/model/User.dart';
import '../../../network/network.dart';

class OptionsCubit extends Cubit<OptionsStates> {
  OptionsCubit() : super(OptionsInitialState());




  start(){
    emit(OptionsHomePageState(isLogOut: false));
  }


  startEditProfile() async {
    emit(OptionsLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var username = sharedPreferences.getString(usernameKey) ?? "";

    try {
      var response = await dio.get(baseUrl + usersApi + username);

      if (response.statusCode == 200) {
        var user = User.fromJson(response.data);

        emit(OptionsEditProfileState(user: user));
      }
    } on DioException catch (e) {
    }
  }

  startChangePassword() async {
    emit(OptionsLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var username = sharedPreferences.getString(usernameKey) ?? "";

    try {
      var response = await dio.get(baseUrl + usersApi + username);

      if (response.statusCode == 200) {
        var user = User.fromJson(response.data);

        emit(OptionsChangePasswordState(user: user));
      }
    } on DioException catch (e) {
    }
  }

  saveEditProfile(String name, String surname, File? image, DateTime dateTime,
      String? phoneNumber, Function(bool, String) fun) async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    String? fileName;
    FormData? formData;
    if (image != null) {
      fileName = image.path.split('/').last;
      formData = FormData.fromMap({
        "ProfilePhoto":
            await MultipartFile.fromFile(image.path, filename: fileName),
        "Name": name,
        "SurName": surname,
        "BirthDate": "${dateTime.toLocal()}".split(' ')[0],
        "PhoneNumber": phoneNumber
      });
    } else {
      formData = FormData.fromMap({
        "Name": name,
        "SurName": surname,
        "BirthDate": "${dateTime.toLocal()}".split(' ')[0],
        "PhoneNumber": phoneNumber
      });
    }

    try {
      var response = await dio.put(baseUrl + updateProfileApi,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
          data: formData);

      if (response.statusCode == 200) {
        fun(true, "Profil yeniləndi");
      }
    } on DioException catch (e) {
      fun(false, "Səhvlik");
    }
  }

  startHelpPage() async {
    emit(OptionsLoadingState());

    var dio = locator.get<Dio>();

    try {
      var response = await dio.get(baseUrl + questionsApi);

      if (response.statusCode == 200) {
        List<Question> questions = (response.data['data'] as List)
            .map((e) => Question.fromJson(e))
            .toList();

        emit(OptionsHelpPageState(questions: questions));
      }
    } on DioException catch (e) {
    }
  }

  changePassword(String oldPassword, String newPassword, String dateTime,
      Function(bool, String) fun) async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);
    var formData = FormData.fromMap({
      "BirthDate": dateTime,
      "OldPassword": oldPassword,
      "NewPassword": newPassword
    });

    try {
      var response = await dio.put(baseUrl + updateProfileApi,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
          data: formData);

      if (response.statusCode == 200) {
        fun(true, "Parol dəyişdirildi!");
      }
    } on DioException catch (e) {
      fun(false, "Köhnə parol səhvdir!");
    }
  }

  startSuggestionPage() {
    emit(OptionsSuggestionPageState());
  }

  sendSuggestion(bool IsTekif, String description, File? Image) async {
    emit(OptionsLoadingState());
    var dio = locator.get<Dio>();
    try {
      FormData? formData;
      if (Image != null) {
        formData = FormData.fromMap({
          "Image": await MultipartFile.fromFile(Image.path,
              filename: Image.path.split('/').last),
          "IsTekif": IsTekif,
          "Description": description,
        });
      }else{
        formData = FormData.fromMap({
          "IsTekif": IsTekif,
          "Description": description,
        });
      }
      var response = await dio.post(baseUrl + suggestionApi,
          data: formData);

      if (response.statusCode == 200) {
        emit(OptionsSuggestionSuccesfullPageState());
      }
    } on DioException catch (e) {
    }
  }

  void logOut() async {

    emit(OptionsLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);
    try {
      var response = await dio.post(
        baseUrl + logOutApi,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 200) {
        await sharedPreferences.clear();
        await sharedPreferences.setBool(shouldShowOnboardKey, false);
        emit(OptionsHomePageState(isLogOut: true));
        homePageCubit = HomePageCubit();
        matchesPageCubit = MatchesCubit();
        teamPageCubit = TeamCubit();
        morePageCubit = MorePageCubit();
        divisionPageCubit = DivisionCubit();
      }else{
        emit(OptionsHomePageState(isLogOut: false));
      }

    } on DioException catch (e) {
      emit(OptionsHomePageState(isLogOut: false));
    }
  }
}
