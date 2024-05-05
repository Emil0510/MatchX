import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/pages/home/divisions_page/widget/division_team.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/model/Division.dart';
import '../../../../network/model/Team.dart';
import '../../team_page/team_detail_cubit/team_detail_cubit.dart';
import '../../team_page/ui/TeamDetailPage.dart';

class DivisionNavigationBar extends StatefulWidget {
  final List<Division> divisions;

  const DivisionNavigationBar({super.key, required this.divisions});

  @override
  State<DivisionNavigationBar> createState() => _DivisionNavigationBarState();
}

class _DivisionNavigationBarState extends State<DivisionNavigationBar> {
  late List<Division> divisions;
  int selected = 0;
  late String selectedDivisionName;
  late List<Team> divisionTeams;

  @override
  void initState() {
    super.initState();
    divisions = widget.divisions;
    divisionTeams = divisions[selected].divisionTeams;
    selectedDivisionName = divisions[selected].divisionName;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          color: const Color(blackColor2),
        ),
        Column(
          children: [
            SizedBox(
              height: 0.4 * width + 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: divisions.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (divisions[index].isActive == true) {
                            setState(
                              () {
                                selected = index;
                                divisionTeams =
                                    divisions[selected].divisionTeams;
                                selectedDivisionName = divisions[selected].divisionName;
                              },
                            );
                          } else {
                            showCustomSnackbar(context,
                                "${divisions[index].divisionName} aktiv deil");

                          }
                        },
                        child: index == selected
                            ? Container(
                                height: 0.3 * width,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(60),
                                        bottomRight: Radius.circular(60)),
                                    color: Colors.black54),
                                child: Image.network(
                                  divisions[index].divisionImage,
                                  width: 0.3 * width,
                                  height: 0.4 * width,
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: 0.05 * width, bottom: 0.05 * width),
                                child: Container(
                                  height: 0.25 * width,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(40),
                                          bottomRight: Radius.circular(40)),
                                      color: Colors.black54),
                                  foregroundDecoration:
                                      divisions[index].isActive == true
                                          ? null
                                          : const BoxDecoration(
                                              color: Colors.grey,
                                              backgroundBlendMode:
                                                  BlendMode.saturation,
                                            ),
                                  child: Image.network(
                                    divisions[index].divisionImage,
                                    width: 0.20 * width,
                                    height: 0.20 * width,
                                    opacity: divisions[index].isActive == true
                                        ? null
                                        : const AlwaysStoppedAnimation(.3),
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                selectedDivisionName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: divisionTeams.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => TeamDetailCubit()
                              ..startTeamDetail(divisionTeams[index].id!),
                            child: TeamDetailPage(
                                teamName: divisionTeams[index].name ?? ""),
                          ),
                        ),
                      );
                    },
                    child: DivisionTeamWidget(
                        order: index + 1, team: divisionTeams[index]),
                  );
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
