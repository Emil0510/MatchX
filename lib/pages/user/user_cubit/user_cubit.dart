import 'package:age_calculator/age_calculator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/pages/user/user_cubit/user_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Constants.dart';
import '../../../network/model/User.dart';
import '../../../network/network.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  start(String username) async {
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

      print(response.statusCode);
      if (response.statusCode == 200) {
        var user = User.fromJson(response.data);

        //Date of birth to age
        var birthDate = user.dateOfBirth?.split('T')[0];
        var joinDate = user.joinDate!.split('T')[0];
        var dateTimeBirth = DateTime(
            int.parse(birthDate!.split('-')[0]),
            int.parse(birthDate.split('-')[1]),
            int.parse(birthDate.split('-')[2]));

        var dateTimeJoin = DateTime(
            int.parse(joinDate.split('-')[0]),
            int.parse(joinDate.split('-')[1]),
            int.parse(joinDate.split('-')[2]));

        var age = AgeCalculator.age(dateTimeBirth).years;

        var format = DateFormat("MMMM dd, yyyy");
        var dateTimeString = format.format(dateTimeBirth);
        var joinTimeString = format.format(dateTimeJoin);

        emit(UserPageState(user: user, age: age));
      } else {
        emit(UserErrorState(message: "Xəta"));
      }
    } on DioException catch (e) {
      emit(UserErrorState(message: "Xəta"));
    }
  }
}