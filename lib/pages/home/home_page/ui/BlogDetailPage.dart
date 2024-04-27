import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils.dart';

import '../../../../Constants.dart';
import '../../../../network/model/Blog.dart';

class BlogDetailPage extends StatelessWidget {
  final Blog blog;

  const BlogDetailPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Xəbər",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: Container(
        width: width,
        height: height,
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
            SingleChildScrollView(
              child: Column(
                children: [
                  blog.imageUrl != null
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              blog.imageUrl!,
                              width: width,
                              height: height / 4,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 8),
                      child: Text(
                        "Tarix: ${getGameDate(blog.createdAt).split(",")[0]}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: height * 3 / 4,
                    color: const Color(blackColor2),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            blog.title ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              blog.description ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
