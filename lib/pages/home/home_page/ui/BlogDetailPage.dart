import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Constants.dart';
import '../../../../network/model/Blog.dart';

class BlogDetailPage extends StatefulWidget {
  final Blog blog;

  const BlogDetailPage({super.key, required this.blog});

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  @override
  void initState() {
    super.initState();
    sendRequestBlog();
  }

  void sendRequestBlog() async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(baseUrl + getBlogIdApi,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          queryParameters: {"id": widget.blog.id});
    } on DioException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var string = "";
    widget.blog.description?.split("||").forEach((element) {
      string += element;
      string += "\n";
    });

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
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  widget.blog.imageUrl != null
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: widget.blog.imageUrl!,
                              width: width,
                              height: height / 4,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: Container(
                                  width: width,
                                  height: height / 4,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 8),
                      child: Text(
                        "Tarix: ${getGameDate(widget.blog.createdAt).split(",")[0]}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    color: const Color(blackColor2),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.blog.title ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                text: TextSpan(
                                  text: string ?? "",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                textAlign: TextAlign.start,
                              )),
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
