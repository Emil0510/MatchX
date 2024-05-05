import 'package:age_calculator/age_calculator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Constants.dart';
import '../../../../network/model/User.dart';
import '../../../../network/network.dart';
import 'more_page_states.dart';

class MorePageCubit extends Cubit<MorePageCubitStates> {
  MorePageCubit() : super(MorePageInitialState());

  User? mine;

  set(User? mine) {
    this.mine = mine;
  }

  start() {
    if (mine != null) {
      startLoaded();
      return;
    }
    emit(MorePageLoadingState());
    fetchProfileData();
  }

  Future<UserData?> refresh() async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var username = sharedPreferences.getString("username") ?? "";
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + usersApi + username,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var user = User.fromJson(response.data);
        mine = user;
        morePageCubit = this;

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

        return UserData(user: mine!, age: age, joinDate: joinDate, birthDate: birthDate);
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
    }
  }

  startLoaded() {
    //Date of birth to age
    var birthDate = mine!.dateOfBirth?.split('T')[0];
    var joinDate = mine!.joinDate!.split('T')[0];
    var dateTimeBirth = DateTime(int.parse(birthDate!.split('-')[0]),
        int.parse(birthDate.split('-')[1]), int.parse(birthDate.split('-')[2]));

    var dateTimeJoin = DateTime(int.parse(joinDate.split('-')[0]),
        int.parse(joinDate.split('-')[1]), int.parse(joinDate.split('-')[2]));

    var age = AgeCalculator.age(dateTimeBirth).years;

    var format = DateFormat("MMMM dd, yyyy");
    var dateTimeString = format.format(dateTimeBirth);
    var joinTimeString = format.format(dateTimeJoin);

    emit(MorePageHomeState(age, joinTimeString, dateTimeString, user: mine!));
  }

  fetchProfileData() async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var username = sharedPreferences.getString("username") ?? "";
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + usersApi + username,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var user = User.fromJson(response.data);
        mine = user;
        morePageCubit = this;

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

        emit(
            MorePageHomeState(age, joinTimeString, dateTimeString, user: user));
      } else {
        emit(MorePageErrorState());
      }
    } on DioException catch (e) {
      emit(MorePageErrorState());
    }
  }
//
// toEditProfile(BuildContext context) async{
//   var cubit = context.read<MorePageCubit>();
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => BlocProvider(
//         create: (context) => cubit,
//         child: EditProfilePage(
//           user: mine!,
//         ),
//       ),
//     ),
//   );
// }
//
// saveEditProfile(
//     String name,
//     String surname,
//     File? image,
//     DateTime dateTime,
//     String? oldPassword,
//     String? newPassword,
//     String? phoneNumber,
//     Function(bool, String) fun) async {
//   var sharedPreferences = locator.get<SharedPreferences>();
//   var dio = locator.get<Dio>();
//   var token = sharedPreferences.getString(tokenKey);
//
//   String? fileName;
//   FormData? formData;
//   if (image != null) {
//     fileName = image.path.split('/').last;
//     formData = FormData.fromMap({
//       "ProfilePhoto":
//           await MultipartFile.fromFile(image.path, filename: fileName),
//       "Name": name,
//       "SurName": surname,
//       "BirthDate": "${dateTime.toLocal()}".split(' ')[0],
//       "OldPassword": oldPassword,
//       "NewPassword": newPassword,
//       "PhoneNumber" : phoneNumber
//     });
//   } else {
//     formData = FormData.fromMap({
//       "Name": name,
//       "SurName": surname,
//       "BirthDate": "${dateTime.toLocal()}".split(' ')[0],
//       "OldPassword": oldPassword,
//       "NewPassword": newPassword,
//       "PhoneNumber" : phoneNumber
//     });
//   }
//
//   try {
//     var response = await dio.put(baseUrl + updateProfileApi,
//         options: Options(
//           headers: {"Authorization": "Bearer $token"},
//         ),
//         data: formData);
//
//     if (response.statusCode == 200) {
//       fun(true, "Profil yeniləndi");
//     }
//   } on DioException catch (e) {
//     print(e.response?.data);
//     fun(false, "Şifrə səhvdir");
//   }
// }
}

class UserData {
  final User user;
  final int age;
  final String joinDate;
  final String birthDate;

  UserData(
      {required this.user,
      required this.age,
      required this.joinDate,
      required this.birthDate});
}
