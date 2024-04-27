import 'package:flutter/material.dart';
import 'package:flutter_app/pages/user/user_cubit/user_cubit.dart';
import 'package:flutter_app/pages/user/user_cubit/user_states.dart';
import 'package:flutter_app/pages/user/user_detail.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants.dart';

class UserLogics extends StatefulWidget {
  final String username;
  const UserLogics({super.key, required this.username});

  @override
  State<UserLogics> createState() => _UserLogicsState();
}

class _UserLogicsState extends State<UserLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCubit>(
      create: (BuildContext context) => UserCubit()..start(widget.username),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: Text(
            widget.username,
            style: const TextStyle(color: Color(goldColor)),
          ),
        ),
        body: BlocBuilder<UserCubit, UserStates>(
          builder: (context, state){
            if(state is UserLoadingState){
              return const CircularLoadingWidget();
            }else if(state is UserErrorState){
              return Text(state.message);
            }else if(state is UserPageState){
              return UserDetailPage(user: state.user, age: state.age);
            }else{
              return const CircularLoadingWidget();
            }
          },
        ),
      ),
    );
  }
}
