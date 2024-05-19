import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/home_page/cubit/home_page_cubit.dart';
import 'package:flutter_app/pages/home/home_page/cubit/home_page_states.dart';
import 'package:flutter_app/pages/home/home_page/ui/HomeMainPage.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageLogics extends StatefulWidget {
  const HomePageLogics({super.key});

  @override
  State<HomePageLogics> createState() => _HomePageLogicsState();
}

class _HomePageLogicsState extends State<HomePageLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageStates>(
        builder: (context, state) {
      if (state is HomePageLoadingState) {
        return const CircularLoadingWidget();
      } else if (state is HomePageErrorState) {
        return const Text("Error");
      } else if (state is HomePageMainState) {
        return HomeMainPage(
          top10Teams: state.top10Teams,
          top10Users: state.top10Users,
          blog: state.blogs,
          weather: state.weather,
        );
      } else {
        return const CircularLoadingWidget();
      }
    });
  }
}
