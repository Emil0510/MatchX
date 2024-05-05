import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../network/model/Blog.dart';

class BlogSingleItem extends StatelessWidget {
  final Blog blog;

  const BlogSingleItem({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: const Color(blackColor2),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  blog.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black, Colors.transparent],
                              ).createShader(Rect.fromLTRB(
                                  0, 0, bounds.width, bounds.height));
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                                blog.imageUrl!,
                                width: width,
                                height: height / 3,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: Container(
                                        width: width*4/5,
                                        height: width*4/5,
                                        color: Colors.black54,
                                      ),
                                    );
                                },
                              ),
                          ),
                        )
                      : const SizedBox(),
                  Positioned(
                    bottom: 0,
                    left: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "BLOQ",
                            style: TextStyle(color: Color(goldColor)),
                          ),
                          Text(
                              " | ${getGameDate(blog.createdAt).split(',')[0]}")
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: width / 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    blog.title ?? "",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
