import 'package:dio/dio.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/model/Division.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/home/divisions_page/division_cubit/DivisionStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DivisionCubit extends Cubit<DivisionStates> {

  DivisionCubit() : super(DivisionInitialState());

  void start()  async{
    print("Start");

    emit(DivisionLoadingState());

    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.get(tokenKey);

    // try {
    //   var response = await dio.get(
    //     baseUrl + allDivisionApi,
    //     options: Options(headers: {"Authorization": "Bearer $token"}),
    //   );
    //
    //   if (response.statusCode == 200) {
    //
    //     var list = (response.data['data'] as List)
    //         .map((e) => Division.fromJson(e))
    //         .toList();
    //
    //
    //     print("List ${list[0].divisionName}");
    //     print("Divisoion list ${response.data}");

        emit(DivisionPageState(divisions: []));

    //   } else {
    //
    //     emit(DivisionErrorState());
    //
    //   }
    //
    // } on DioException catch (e) {
    //   emit(DivisionErrorState());
    // }

  }
}
