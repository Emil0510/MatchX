import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/home_page/cubit/home_page_cubit.dart';
import 'package:flutter_app/widgets/infinity_scroll_loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants.dart';
import '../../../../network/model/Blog.dart';
import '../widgets/blog_item.dart';
import 'BlogDetailPage.dart';

class BlogsPage extends StatefulWidget {
  final List<Blog> blogs;

  const BlogsPage({super.key, required this.blogs});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  late List<Blog> blogs;
  int page = 1;
  bool isEnd = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    blogs = widget.blogs;

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          !isEnd) {
        //Fetch Data
        page++;
        context.read<HomePageCubit>().loadMoreBlogs(page, (list) {
          if (list.isEmpty) {
            setState(() {
              isEnd = true;
            });
            return;
          } else {
            setState(() {
              blogs.addAll(list);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Xəbərlər",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          var list = await context.read<HomePageCubit>().refreshBlogs();
          setState(() {
            blogs = list;
          });
        },
        child: Container(
          width: width,
          height: height,
          color: Colors.black,
          child: ListView.builder(
              itemCount:
                  (blogs.length % 10 == 0 && blogs.isNotEmpty) ? blogs.length + 1 : blogs.length,
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index < blogs.length) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BlogDetailPage(blog: blogs[index])),
                      );
                    },
                    child: BlogSingleItem(
                      blog: blogs[index],
                    ),
                  );
                } else {
                  if (isEnd) {
                    return const SizedBox();
                  } else {
                    return const InfinityScrollLoading();
                  }
                }
              },
            ),
          ),
        ),
    );
  }
}
