import 'package:dio/dio.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/data.dart';
import 'package:flutter_app/network/model/Blog.dart';
import 'package:flutter_app/network/model/Team.dart';
import 'package:flutter_app/network/model/User.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/home/home_page/cubit/home_page_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../network/model/Weather.dart';

class HomePageCubit extends Cubit<HomePageStates> {
  HomePageCubit() : super(HomePageInitialState());

  List<Blog> blogs = [];
  List<User> top10Users = [];
  List<Team> top10Teams = [];
  Weather? weather;
  bool isLoaded = false;

  set(List<Blog> blogs, List<User> top10Users, List<Team> top10Teams,
      Weather? weather, bool isLoaded) {
    this.blogs = blogs;
    this.top10Users = top10Users;
    this.top10Teams = top10Teams;
    this.weather = weather;
    this.isLoaded = isLoaded;
  }

  start() async {
    if (isLoaded) {
      emit(
        HomePageMainState(
            top10Teams: top10Teams,
            top10Users: top10Users,
            blogs: blogs,
            weather: weather!),
      );
      return;
    }
    emit(HomePageLoadingState());

    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(baseUrl + getBlogsApi,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        List<Blog> list = (response.data['data']['blogs'] as List)
            .map((e) => Blog.fromJson(e))
            .toList();

        blogs = list;

        var response2 = await dio.get(baseUrl + getTopUsersApi);

        if (response2.statusCode == 200) {
          List<User> top10Users = (response2.data['data'] as List)
              .map((e) => User.fromJson(e))
              .toList();

          var response3 = await dio.get(baseUrl + getTopTeamsApi);
          if (response3.statusCode == 200) {
            List<Team> top10Teams = (response3.data['data'] as List)
                .map((e) => Team.fromJson(e))
                .toList();

            _getWeather(top10Teams, top10Users, list);
          }
        }
      }
    } on DioException catch (e) {}
  }

  Future<HomeData> refresh() async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(baseUrl + getBlogsApi,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        List<Blog> list = (response.data['data']['blogs'] as List)
            .map((e) => Blog.fromJson(e))
            .toList();

        blogs = list;

        var response2 = await dio.get(baseUrl + getTopUsersApi);

        if (response2.statusCode == 200) {
          List<User> top10Users = (response2.data['data'] as List)
              .map((e) => User.fromJson(e))
              .toList();

          var response3 = await dio.get(baseUrl + getTopTeamsApi);
          if (response3.statusCode == 200) {
            List<Team> top10Teams = (response3.data['data'] as List)
                .map((e) => Team.fromJson(e))
                .toList();

            const String BASE_URL = "http://api.weatherapi.com/v1";
            const String API = "/current.json";
            const String API_KEY = "2544768bac5847bfafe215709242603";

            String q = "40.409264,49.867092";

            try {
              var response = await dio.get(
                BASE_URL + API,
                queryParameters: {"key": API_KEY, "q": q, "lang": "tr"},
              );

              if (response.statusCode == 200) {
                var weather = Weather.fromJson(response.data);
                this.top10Teams = top10Teams;
                this.top10Users = top10Users;
                blogs = blogs;
                this.weather = weather;
                isLoaded = true;
                homePageCubit = this;

                return HomeData(
                    blogs, this.top10Users, this.top10Teams, this.weather);
              } else {
                return HomeData(
                    blogs, this.top10Users, this.top10Teams, weather);
              }
            } on DioException catch (e) {
              return HomeData(
                  blogs, this.top10Users, this.top10Teams, weather);
            }
          } else {
            return HomeData(
                blogs, this.top10Users, top10Teams, weather);
          }
        } else {
          return HomeData(
              blogs, top10Users, top10Teams, weather);
        }
      } else {
        return HomeData(blogs, top10Users, top10Teams, weather);
      }
    } on DioException catch (e) {
      return HomeData(blogs, top10Users, top10Teams, weather);
    }
  }



  void _getWeather(
      List<Team> top10Teams, List<User> top10Users, List<Blog> blogs) async {
    var dio = locator.get<Dio>();

    const String BASE_URL = "http://api.weatherapi.com/v1";
    const String API = "/current.json";
    const String API_KEY = "2544768bac5847bfafe215709242603";

    String q = "40.409264,49.867092";

    try {
      var response = await dio.get(
        BASE_URL + API,
        queryParameters: {"key": API_KEY, "q": q, "lang": "tr"},
      );

      if (response.statusCode == 200) {
        var weather = Weather.fromJson(response.data);
        this.top10Teams = top10Teams;
        this.top10Users = top10Users;
        this.blogs = blogs;
        this.weather = weather;
        isLoaded = true;
        homePageCubit = this;
        emit(
          HomePageMainState(
              top10Teams: top10Teams,
              top10Users: top10Users,
              blogs: blogs,
              weather: weather),
        );
      }
    } on DioException catch (e) {}
  }

  getBlogs() async {
    emit(HomePageLoadingState());
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(baseUrl + getBlogsApi,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        List<Blog> list = (response.data['data']['blogs'] as List)
            .map((e) => Blog.fromJson(e))
            .toList();

        emit(
          HomePageBlogsState(
            blogs: list,
          ),
        );
      }
    } on DioException catch (e) {}
  }

  Future<List<Blog>> refreshBlogs() async{
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(baseUrl + getBlogsApi,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        List<Blog> list = (response.data['data']['blogs'] as List)
            .map((e) => Blog.fromJson(e))
            .toList();
        return list;
      }else{
        return [];
      }
    } on DioException catch (e) {
      return [];
    }
  }

  void loadMoreBlogs(int page, Function (List<Blog>) callback) async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + getBlogsApi,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
        queryParameters: {"page": page},
      );

      if (response.statusCode == 200) {
        List<Blog> list = (response.data['data']['blogs'] as List)
            .map((e) => Blog.fromJson(e))
            .toList();

        blogs.addAll(list);

        callback(list);

      }else{
        callback([]);
      }
    } on DioException catch (e) {
      callback([]);
    }
  }
}

class HomeData {
  final List<Blog> blogs;

  final List<User> top10Users;
  final List<Team> top10Teams;

  final Weather? weather;

  HomeData(this.blogs, this.top10Users, this.top10Teams, this.weather);
}
