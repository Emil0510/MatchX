import 'package:flutter/material.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/create_team_logics.dart';
import 'package:flutter_app/pages/home/team_page/widgets/team_button_child.dart';
import 'package:flutter_app/widgets/list_view.dart';
import 'package:flutter_app/widgets/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants.dart';
import '../../../../network/model/Team.dart';
import '../../../../widgets/buttons_widgets.dart';
import '../../../../widgets/input_text_widgets.dart';
import '../team_cubit/team_cubit.dart';
import '../team_detail_cubit/team_detail_cubit.dart';
import 'CreateTeamPage.dart';
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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                  onTap: (){
                    searchButtonClicked();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(goldColor),
                      borderRadius: BorderRadius.circular(16),),
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
                              create: (context) =>
                                  TeamDetailCubit()..startTeamDetail(id ?? ""),
                              child: const TeamDetailPage(teamName: "Komandam"),
                            ),
                          ),
                        );

                        print("Komandam  ${data}");
                        if (data != null) {
                          context.read<TeamCubit>().start();
                        }
                      } else {
                        var data = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings:
                                const RouteSettings(name: createTeamRoute),
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
                      text: checkExistingTeam() ? "Komandam" : "Komanda yarat",
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.teams.length,
            itemBuilder: (context, index) {
              return TeamListItem(team: widget.teams.elementAt(index));
            },
          ),
        ),
      ],
    );
  }
}
