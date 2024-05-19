import 'package:age_calculator/age_calculator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/pages/user/user_cubit/user_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Constants.dart';
import '../../../network/model/User.dart';
import '../../../network/network.dart';
import '../../home/more_page/more_cubit/more_page_cubit.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  String username = "";
  start(String username) async {
    this.username = username;
    emit(UserLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + usersApi + username,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        var user = User.fromJson(response.data);

        //Date of birth to age
        var birthDate = user.dateOfBirth?.split('T')[0];

        var dateTimeBirth = DateTime(
            int.parse(birthDate!.split('-')[0]),
            int.parse(birthDate.split('-')[1]),
            int.parse(birthDate.split('-')[2]));

        var age = AgeCalculator.age(dateTimeBirth).years;


        emit(UserPageState(user: user, age: age));
      } else {
        emit(UserErrorState(message: "Xəta"));
      }
    } on DioException catch (e) {
      emit(UserErrorState(message: "Xəta"));
    }
  }

  Future<UserData?> refresh () async{
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + usersApi + username,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        var user = User.fromJson(response.data);

        //Date of birth to age
        var birthDate = user.dateOfBirth?.split('T')[0];
        var joinDate = user.joinDate!.split('T')[0];
        var dateTimeBirth = DateTime(
            int.parse(birthDate!.split('-')[0]),
            int.parse(birthDate.split('-')[1]),
            int.parse(birthDate.split('-')[2]));


        var age = AgeCalculator.age(dateTimeBirth).years;


        return UserData(user: user, age: age, joinDate: joinDate, birthDate: birthDate);
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
    }
  }
}
