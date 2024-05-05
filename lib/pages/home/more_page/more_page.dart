import 'package:flutter/material.dart';
import 'package:flutter_app/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'more_cubit/more_page_cubit.dart';
import 'more_cubit/more_page_logics.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MorePageCubit()
        ..set(morePageCubit.mine)
        ..start(),
      child: const MorePageLogics(),
    );
  }
}
