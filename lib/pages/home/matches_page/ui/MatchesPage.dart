import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/pages/home/matches_page/mathches_cubit/matches_cubit.dart';
import 'package:flutter_app/pages/home/matches_page/ui/widgets/mathes_list.dart';
import 'package:flutter_app/widgets/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/model/Game.dart';

class AllMatchesPage extends StatefulWidget {
  final List<TeamGame>? games;
  final int selectedId;

  const AllMatchesPage(
      {super.key, required this.games, required this.selectedId});

  @override
  State<AllMatchesPage> createState() => _AllMatchesPageState();
}

class _AllMatchesPageState extends State<AllMatchesPage> {
  String selectedRegion = 'Hamısı';
  int selectedRegionId = -1;
  List<String> regions = [
    'Hamısı',
    "Abşeron",
    "Ağcabədi",
    "Ağdam",
    "Ağdaş",
    "Ağstafa",
    "Ağsu",
    "Astara",
    "Bakı",
    "Balakən",
    "Bərdə",
    "Beyləqan",
    "Biləsuvar",
    "Cəbrayıl",
    "Cəlilabad",
    "Daşkəsən",
    "Füzuli",
    "Gəncə",
    "Gədəbbəy",
    "Göyçay",
    "Göygöl",
    "Görəle",
    "Hacıqabul",
    "Xaçmaz",
    "Xankəndi",
    "Xızı",
    "Xocalı",
    "Xocavənd",
    "İmişli",
    "İsmayıllı",
    "Kəlbəcər",
    "Kürdəmir",
    "Qax",
    "Qazax",
    "Qəbələ",
    "Qobustan",
    "Quba",
    "Qubadlı",
    "Qusar",
    "Laçın",
    "Lənkəran",
    "Lerik",
    "Masallı",
    "Mingəçevir",
    "Naftalan",
    "Naxçıvan",
    "Neftçala",
    "Oğuz",
    "Qabala",
    "Qakh",
    "Qaradağ",
    "Qazakh",
    "Saatlı",
    "Sabirabad",
    "Şabran",
    "Şahbuz",
    "Şəki",
    "Şəmkir",
    "Şirvan",
    "Siazan",
    "Sumqayıt",
    "Tərtər",
    "Tovuz",
    "Ucar",
    "Yardımlı",
    "Yevlakh",
    "Zəngilan",
    "Zaqatala",
    "Zərdab"
  ];

  @override
  void initState() {
    super.initState();
    selectedRegionId = widget.selectedId;
    selectedRegion = regions[selectedRegionId];
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          checkLeader()
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      context.read<MatchesCubit>().toFinishedGames(context);
                    },
                    child: Container(
                      height: 40,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: const Color(blackColor2),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: GoldColorText(text: "Oyunlarım"),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          checkLeader()
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      context.read<MatchesCubit>().toCreateMatch(context);
                    },
                    child: Container(
                      height: 40,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: const Color(blackColor2),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: GoldColorText(text: "Oyun yarat"),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          checkLeader()
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<MatchesCubit>()
                                  .toCreateWithLinkPage(context);
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: const Color(blackColor2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                child: GoldColorText(text: "Link ilə oyun yarat"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<MatchesCubit>()
                                  .toJoinWithLinkPage(context);
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: const Color(blackColor2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                child:
                                    GoldColorText(text: "Link ilə oyuna qoşul"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                context.read<MatchesCubit>().toCreateMatch(context);
              },
              child: Container(
                height: 40,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: const Color(blackColor2),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedRegion,

                  hint: const Text('Region'),
                  menuMaxHeight: height / 2,
                  alignment: Alignment.bottomCenter,
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    selectedRegion = newValue!;
                    selectedRegionId = regions.indexOf(newValue) - 1;
                    print(selectedRegionId);
                    context
                        .read<MatchesCubit>()
                        .getSelectedRegionGames(selectedRegionId);
                  },
                  dropdownColor: Colors.black,
                  items: regions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        width: width,
                        color: const Color(blackColor2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value,
                            style: const TextStyle(color: Color(goldColor)),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Oyunlar:",
                  style: TextStyle(color: Color((goldColor)), fontSize: 18),
                )),
          ),
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.games?.length ?? 0,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context
                        .read<MatchesCubit>()
                        .toGameDetail(widget.games![index], context, false, "");
                  },
                  child: MatchesListItem(
                    teamGame: widget.games![index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}