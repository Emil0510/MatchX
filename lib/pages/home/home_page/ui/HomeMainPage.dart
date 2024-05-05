import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/model/Blog.dart';
import 'package:flutter_app/network/model/Weather.dart';
import 'package:flutter_app/pages/home/home_page/cubit/blog_page_logics.dart';
import 'package:flutter_app/pages/home/home_page/cubit/home_page_cubit.dart';
import 'package:flutter_app/pages/home/home_page/ui/BlogDetailPage.dart';
import 'package:flutter_app/pages/home/home_page/widgets/blog_item.dart';
import 'package:flutter_app/pages/home/home_page/widgets/home_list_items.dart';
import 'package:flutter_app/pages/home/home_page/widgets/user_carusel_item.dart';
import 'package:flutter_app/pages/home/home_page/widgets/weather_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/model/Team.dart';
import '../../../../network/model/User.dart';
import '../../../user/user_cubit/user_logics.dart';
import '../../team_page/team_detail_cubit/team_detail_cubit.dart';
import '../../team_page/ui/TeamDetailPage.dart';

class HomeMainPage extends StatefulWidget {
  final List<Team> top10Teams;
  final List<User> top10Users;
  final List<Blog> blog;
  final Weather weather;

  const HomeMainPage(
      {super.key,
      required this.top10Teams,
      required this.top10Users,
      required this.blog,
      required this.weather});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  late List<Team> top10Teams;
  late List<User> top10Users;
  late List<Blog> blog;
  late Weather weather;

  @override
  void initState() {
    super.initState();
    top10Teams = widget.top10Teams;
    top10Users = widget.top10Users;
    blog = widget.blog;
    weather = widget.weather;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        var data = await context.read<HomePageCubit>().refresh();
        setState(() {
          top10Teams = data.top10Teams;
          top10Users = data.top10Users;
          blog = data.blogs;
          weather = data.weather!;
        });
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: WeatherWidget(weather: weather),
            ),
            blog.isEmpty
                ? const SizedBox()
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Xəbərlər",
                              style: TextStyle(
                                  color: Color(goldColor),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BlocProvider<HomePageCubit>(
                                        create: (BuildContext context) =>
                                            HomePageCubit()..getBlogs(),
                                        child: const BlogPageLogics(),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(blackColor2),
                                ),
                                child: const Text(
                                  "Xəbərlərə keçin",
                                  style: TextStyle(color: Colors.white70),
                                )),
                          )
                        ],
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BlogDetailPage(blog: blog[index])),
                                );
                              },
                              child: BlogSingleItem(blog: blog[index]));
                        },
                      ),
                    ],
                  ),
            SizedBox(
              height: height / 20,
            ),
            top10Teams.isEmpty
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Top 10 Komanda",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
            SizedBox(
              height: height / 40,
            ),
            top10Teams.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(blackColor2),
                              borderRadius: BorderRadius.circular(5)),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Text(
                                        "Yer",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                Expanded(
                                  flex: 18,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Komanda adı",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Son 3",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Center(
                                    child: Text("Xal",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: top10Teams.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => TeamDetailCubit()
                                      ..startTeamDetail(top10Teams[index].id!),
                                    child: TeamDetailPage(
                                        teamName: top10Teams[index].name ?? ""),
                                  ),
                                ),
                              );
                            },
                            child: Top10TeamSingleItem(
                                team: top10Teams[index], index: index),
                          );
                        },
                      ),
                    ],
                  )
                : const SizedBox(),
            SizedBox(
              height: height / 20,
            ),
            top10Users.isEmpty
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Top 10 Bombardir",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
            SizedBox(
              height: height / 40,
            ),
            top10Users.isEmpty
                ? const SizedBox()
                : CarouselSlider.builder(
                    itemCount: top10Users.length > 3 ? 3 : top10Users.length,
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) =>
                        UserCaruselItem(
                      user: top10Users[itemIndex],
                      index: itemIndex,
                    ),
                  ),
            SizedBox(
              height: height / 20,
            ),
            top10Users.length > 3
                ? Container(
                    color: const Color(blackColor2),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                "Yer",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                        ),
                        Expanded(
                          flex: 18,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TopListContainer(
                              color: Color(blackColor2),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Ad Soyad",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                                child: Text("Qol sayı",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                        Expanded(
                          flex: 11,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text("Ortalama",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: top10Users.length > 3 ? top10Users.length - 3 : 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserLogics(
                              username: top10Users[index + 3].userName ?? ""),
                        ),
                      );
                    },
                    child: Top10UserSingleItem(
                        user: top10Users[index + 3], index: index + 3),
                  );
                }),
            SizedBox(
              height: (top10Users.length > 3) ? height / 20 : 0,
            ),
          ],
        ),
      ),
    );
  }
}
