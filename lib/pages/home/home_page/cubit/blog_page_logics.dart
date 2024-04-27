import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/home_page/cubit/home_page_cubit.dart';
import 'package:flutter_app/pages/home/home_page/cubit/home_page_states.dart';
import 'package:flutter_app/pages/home/home_page/ui/BlogsPage.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPageLogics extends StatefulWidget {
  const BlogPageLogics({super.key});

  @override
  State<BlogPageLogics> createState() => _BlogLPageLogicsState();
}

class _BlogLPageLogicsState extends State<BlogPageLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageStates>(
        builder: (context, state) {
      if (state is HomePageLoadingState) {
        return const CircularLoadingWidget();
      } else if (state is HomePageErrorState) {
        return const Text("Error");
      } else if (state is HomePageBlogsState) {
        return BlogsPage(blogs: state.blogs);
      } else {
        return const CircularLoadingWidget();
      }
    });
  }
}
