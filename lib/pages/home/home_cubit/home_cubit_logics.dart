// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:match_x_app/pages/home/home_cubit/home_cubit.dart';
// import 'package:match_x_app/pages/home/home_cubit/home_cubit_states.dart';
// import 'package:match_x_app/pages/home/team_page/TeamPage.dart';
//
// class HomeCubitLogics extends StatefulWidget {
//   const HomeCubitLogics({super.key});
//
//   @override
//   State<HomeCubitLogics> createState() => _HomeCubitLogicsState();
// }
//
// class _HomeCubitLogicsState extends State<HomeCubitLogics> {
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubits, HomeCubitStates>(
//       builder: (context, state) {
//         if (state is HomePageState) {
//           return Container(
//             height: double.maxFinite,
//             width: double.maxFinite,
//             decoration: const BoxDecoration(color: Colors.black),
//             child: const Text(
//               '',
//               style: optionStyle,
//             ),
//           );
//         } else if (state is MatchesPageState) {
//           return Container(
//             height: double.maxFinite,
//             width: double.maxFinite,
//             decoration: const BoxDecoration(color: Colors.black),
//             child: const Text(
//               '',
//               style: optionStyle,
//             ),
//           );
//         } else if (state is StadiumsPageState) {
//           return Container(
//             height: double.maxFinite,
//             width: double.maxFinite,
//             decoration: const BoxDecoration(color: Colors.black),
//             child: const Text(
//               '',
//               style: optionStyle,
//             ),
//           );
//         } else if (state is TeamsPageState) {
//           return const TeamPage();
//         } else if (state is MorePageState) {
//           return Container(
//             height: double.maxFinite,
//             width: double.maxFinite,
//             decoration: const BoxDecoration(color: Colors.black),
//             child: const Text(
//               '',
//               style: optionStyle,
//             ),
//           );
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
// }
