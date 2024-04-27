import 'package:flutter/material.dart';

import '../../../../Constants.dart';
import '../../../../network/model/Blog.dart';
import '../widgets/blog_item.dart';
import 'BlogDetailPage.dart';

class BlogsPage extends StatelessWidget {
  final List<Blog> blogs;

  const BlogsPage({super.key, required this.blogs});

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
      body: Container(
        width: width,
        height: height,
        color: Colors.black,
        child: ListView.builder(
          itemCount: blogs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BlogDetailPage(blog: blogs[index])),
                  );
                },
                child: BlogSingleItem(blog: blogs[index]));
          },
        ),
      ),
    );
  }
}
