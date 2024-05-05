import 'package:dio/dio.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/data.dart';
import 'package:flutter_app/network/model/Division.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/home/divisions_page/division_cubit/DivisionStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DivisionCubit extends Cubit<DivisionStates> {

  DivisionCubit() : super(DivisionInitialState());

  List<Division> list = [];


  set(List<Division> list){
    this.list = list;
  }
  void start()  async{
    print("Start");
    if(list.isNotEmpty){
      emit(DivisionPageState(divisions: list));
      return;
    }

    emit(DivisionLoadingState());

    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.get(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + allDivisionApi,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {

        List<Division> list = (response.data['data'] as List)
            .map((e) => Division.fromJson(e))
            .toList();
        this.list = list;
        divisionPageCubit = this;

        emit(DivisionPageState(divisions: list));

      } else {

        emit(DivisionErrorState());

      }

    } on DioException catch (e) {
      emit(DivisionErrorState());
    }

  }
}
