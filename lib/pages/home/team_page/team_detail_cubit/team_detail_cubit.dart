import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/home/more_page/ui/widget/team_widget.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../network/model/Team.dart';

class TeamDetailCubit extends Cubit<TeamDetailCubitStates> {
  TeamDetailCubit() : super(TeamDetailInitialState());

  Team? team;
  late String teamId;

  startTeamDetail(String teamId) async {
    this.teamId = teamId;
    emit(TeamDetailLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString("token");

    var response = await dio.get(
      baseUrl + teamDetailApi + teamId.toString(),
      options: Options(headers: {
        "Authorization": "Bearer $token",
      }),
    );

    if (response.statusCode == 200) {
      var team = Team.fromJson(response.data['data']);
      print(response.data);
      this.team = team;
      emit(TeamDetailPageState(
          team: team, isSuccessful: false, message: "", isThrow: false));
    } else {
      emit(TeamDetailErrorState());
    }
  }

  startEditTeam(Team team) {
    this.team = team;
    emit(TeamDetailLoadingState());
    emit(EditTeamPageState(isSuccessful: false, message: "", team: team));
  }

  editTeam(String teamName, String teamDescription, File? teamLogo, bool isPrivate) async {
    emit(TeamDetailLoadingState());

    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    print("Name $teamName");
    String? fileName;
    FormData? formData;

    if (teamLogo != null) {
      fileName = teamLogo.path.split('/').last;
      formData = FormData.fromMap({
        "TeamLogo":
            await MultipartFile.fromFile(teamLogo.path, filename: fileName),
      });
    } else {
      formData = FormData.fromMap({});
    }

    Map<String, dynamic> body = {
      "Name": teamName,
      "Description": teamDescription,
      "IsPrivate": isPrivate,
    };

    try {
      var response = await dio.put(baseUrl + editTeamApi,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData,
          queryParameters: body);

      if (response.statusCode == 200) {
        print(response.data);
        if(response.data['success']){
          emit(EditTeamPageState(
              team: team, isSuccessful: true, message: "Dəyişdirildi"));
        }else{
          emit(EditTeamPageState(
              team: team, isSuccessful: false, message: response.data['message']));
        }
      } else {
        emit(EditTeamPageState(
            team: team, isSuccessful: false, message: response.data['message']));
      }


    } on DioException catch (e) {
      print(e.response?.data);

      emit(EditTeamPageState(
          team: team, isSuccessful: false, message: e.response?.data));
    }
  }

  refresh(bool isSuccesfull) async {
    emit(TeamDetailLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString("token");

    var response = await dio.get(
      baseUrl + teamDetailApi + teamId.toString(),
      options: Options(headers: {
        "Authorization": "Bearer $token",

      }),
    );

    if (response.statusCode == 200) {
      var team = Team.fromJson(response.data['data']);
      print(response.data);
      this.team = team;
      emit(TeamDetailPageState(
          team: team, isSuccessful: isSuccesfull, message: "", isThrow: false));
    } else {
      emit(TeamDetailErrorState());
    }
  }

  startCreateTeam() {
    emit(TeamDetailLoadingState());
    emit(TeamCreatePageState(isSuccessful: false, message: ""));
  }

  void throwUser(
    String userId,
  ) async {
    emit(TeamDetailLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.post(
        baseUrl + throwUserApi + userId,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        emit(TeamDetailPageState(
            team: team!,
            isSuccessful: true,
            message: "Oyunçu komandadan atıldı",
            isThrow: true));
      } else {
        emit(TeamDetailPageState(
            team: team!,
            isSuccessful: false,
            message: "Xəta baş verdi",
            isThrow: true));
      }
    } on DioException catch (e) {
      print(e.response?.data);
      emit(TeamDetailPageState(
          team: team!,
          isSuccessful: false,
          message: "Xəta baş verdi",
          isThrow: true));
    }
  }

  deleteTeam() async {
    emit(TeamDetailLoadingState());
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);
    try {
      var response = await dio.delete(
        baseUrl + deleteTeamApi,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 200) {
        print(response.data);
        String token = response.data['data'];
        await sharedPreferences.setString(tokenKey, token);
        var list = ["User"];
        await sharedPreferences.setStringList(rolesKey, list);
        await sharedPreferences.setString(myTeamIdKey, "");

        emit(TeamDetailPageState(
            isThrow: false,
            team: team!,
            isSuccessful: true,
            message: "Komanda silindi"));
      }
    } on DioException catch (e) {
      print(e.response?.data);

      emit(TeamDetailPageState(
          isThrow: false,
          team: team!,
          isSuccessful: false,
          message: "Xəta baş verdi"));
    }
  }

  joinTeam(String teamId, bool isPrivate) async {
    emit(TeamDetailLoadingState());
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.post(
        baseUrl + joinTeamApi + teamId.toString(),
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        if (isPrivate) {
          emit(TeamDetailPageState(
              isThrow: false,
              team: team!,
              isSuccessful: true,
              message: "Sorğu göndərildi"));
        } else {
          await sharedPreferences.setString(myTeamIdKey, teamId);
          emit(TeamDetailPageState(
              isThrow: false,
              team: team!,
              isSuccessful: true,
              message: "Komandaya qoşuldun"));
        }
      }
    } on DioException catch (e) {
      print(e.response?.data);

      emit(TeamDetailPageState(
          isThrow: false,
          team: team!,
          isSuccessful: false,
          message: e.response?.data));
    }
  }

  leftTeam() async {
    emit(TeamDetailLoadingState());
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.post(
        baseUrl + leftTeamApi,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        emit(TeamDetailPageState(
            team: team!,
            isSuccessful: true,
            message: "Komandadan ayıldın",
            isThrow: false));
        await sharedPreferences.setString(myTeamIdKey, "");
      }
    } on DioException catch (e) {
      print(e.response?.data);

      emit(TeamDetailPageState(
          team: team!,
          isSuccessful: false,
          message: e.response?.data,
          isThrow: false));
    }
  }

  createTeam(String teamName, String teamDescription, File? teamLogo,
      String phoneNumber, bool isPrivate) async {
    emit(TeamDetailLoadingState());

    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    print("Name $teamName");
    String? fileName;
    FormData? formData;

    if (teamLogo != null) {
      fileName = teamLogo.path.split('/').last;
      formData = FormData.fromMap({
        "TeamLogo":
            await MultipartFile.fromFile(teamLogo.path, filename: fileName),
        "Name": teamName,
        "Description": teamDescription,
        "IsPrivate": isPrivate,
        "PhoneNumber": phoneNumber,
      });
    } else {
      formData = FormData.fromMap({
        "Name": teamName,
        "Description": teamDescription,
        "IsPrivate": isPrivate,
        "PhoneNumber": phoneNumber,
      });
    }

    Map<String, dynamic> body = {
      "Name": teamName,
      "Description": teamDescription,
      "IsPrivate": isPrivate,
      "PhoneNumber": phoneNumber,
    };

    try {
      var response = await dio.post(baseUrl + teamCreateApi,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData);

      if (response.statusCode == 200) {
        var teamId = response.data["data"]['teamId'];
        var token = response.data["data"]['token'];

        var roles = sharedPreferences.getStringList(rolesKey);
        roles?.add("TeamCapitan");

        await sharedPreferences.setString(myTeamIdKey, teamId);
        await sharedPreferences.setStringList(rolesKey, roles ?? []);
        await sharedPreferences.setString(tokenKey, token);

        emit(TeamCreatePageState(
            isSuccessful: true, message: "Komanda yaradıldı"));
      }
      print(response.data);
    } on DioException catch (e) {
      print(e.response?.data);

      emit(TeamCreatePageState(isSuccessful: false, message: e.response?.data));
    }
  }
}
