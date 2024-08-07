import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/data.dart';
import 'package:flutter_app/pages/home/home_page/cubit/home_page_cubit.dart';
import 'package:flutter_app/pages/home/home_page/cubit/home_page_logics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Colors.black,
      child: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Image.asset(
              "assets/background3.jpeg",
              opacity: const AlwaysStoppedAnimation(.3),
              width: width,
              height: height,
              fit: BoxFit.fill,
            ),
          ),
          BlocProvider<HomePageCubit>(
            create: (BuildContext context) => HomePageCubit()
              ..set(
                  homePageCubit.blogs,
                  homePageCubit.top10Users,
                  homePageCubit.top10Teams,
                  homePageCubit.weather,
                  homePageCubit.isLoaded)
              ..start(),
            child: const HomePageLogics(),
          ),
        ],
      ),
    );
  }
}
