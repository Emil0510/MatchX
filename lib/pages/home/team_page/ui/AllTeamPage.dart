import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/create_team_logics.dart';
import 'package:flutter_app/pages/home/team_page/widgets/team_button_child.dart';
import 'package:flutter_app/widgets/infinity_scroll_loading.dart';
import 'package:flutter_app/widgets/list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants.dart';
import '../../../../network/model/Team.dart';
import '../../../../widgets/input_text_widgets.dart';
import '../team_cubit/team_cubit.dart';
import '../team_detail_cubit/team_detail_cubit.dart';
import 'FilterPage.dart';
import 'TeamDetailPage.dart';

class AllTeamPage extends StatefulWidget {
  final List<Team> teams;

  const AllTeamPage({super.key, required this.teams});

  @override
  State<AllTeamPage> createState() => _AllTeamPageState();
}

class _AllTeamPageState extends State<AllTeamPage> {
  late TextEditingController _searchController;
  late List<Team> teams;
  bool isEnd = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    teams = widget.teams;
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          !isEnd) {
        //Fetch Data
        context.read<TeamCubit>().loadMore((newItems) {
          if (newItems.isEmpty) {
            setState(() {
              isEnd = true;
            });
            return;
          } else {
            setState(() {
              teams.addAll(newItems);
            });
          }
        });
      }
    });
  }

  void searchButtonClicked() {
    if (_searchController.text.trim() != "") {
      context.read<TeamCubit>().loadWithSearch(_searchController.text.trim());
    }
  }

  void sendRequest() {}

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async {
        var data = await context.read<TeamCubit>().refresh();
        setState(() {
          teams = data;
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: height / 16,
                            decoration: BoxDecoration(
                                color: const Color(blackColor),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: CustomTextFieldWidget(
                                controller: _searchController,
                                hintText: "Komanda Axtar"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width / 5,
                        height: height / 18,
                        child: GestureDetector(
                          onTap: () {
                            searchButtonClicked();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(goldColor),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                "Axtar",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: height / 18 - 16,
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (innerContext) {
                                  // Return your bottom sheet content here
                                  return BlocProvider.value(
                                    value: BlocProvider.of<TeamCubit>(context,
                                        listen: false),
                                    child: const FilterPage(),
                                  );
                                },
                              );
                            },
                            child: const TeamButtonContainer(
                              text: "Filtrələ",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: GestureDetector(
                            onTap: () async {
                              if (checkExistingTeam()) {
                                var id = getMyTeamId();
                                var data = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => TeamDetailCubit()
                                        ..startTeamDetail(id ?? ""),
                                      child: const TeamDetailPage(
                                          teamName: "Komandam"),
                                    ),
                                  ),
                                );

                                print("Komandam  ${data}");
                                if (data != null) {
                                  context.read<TeamCubit>().isLoaded = false;
                                  context.read<TeamCubit>().start();
                                }
                              } else {
                                var data = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: const RouteSettings(
                                        name: createTeamRoute),
                                    builder: (context) => BlocProvider(
                                      create: (context) =>
                                          TeamDetailCubit()..startCreateTeam(),
                                      child: const TeamCreateLogics(),
                                    ),
                                  ),
                                );
                                print("Komandam  ${data}");
                                if (data != null) {
                                  context.read<TeamCubit>().start();
                                }
                              }
                            },
                            child: TeamButtonContainer(
                              text: checkExistingTeam()
                                  ? "Komandam"
                                  : "Komanda yarat",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height/1.5,
                  child: ListView.builder(
                    itemCount: (teams.length % 10 == 0 && teams.isNotEmpty ) ?teams.length + 1 : teams.length,
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index < teams.length) {
                        return TeamListItem(team: teams.elementAt(index));
                      } else {
                        if (!isEnd) {
                          return const InfinityScrollLoading();
                        } else {
                          return const SizedBox();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
        ),
    );
  }
}
