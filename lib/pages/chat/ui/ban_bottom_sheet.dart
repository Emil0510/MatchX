import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants.dart';
import '../../../widgets/buttons_widgets.dart';
import '../../../widgets/input_text_widgets.dart';
import '../cubit/chat_cubit.dart';

class BanBottomSheet extends StatefulWidget {
  final String username;

  const BanBottomSheet({super.key, required this.username});

  @override
  State<BanBottomSheet> createState() => _BanBottomSheetState();
}

class _BanBottomSheetState extends State<BanBottomSheet> {
  late TextEditingController reportController;
  bool isReportLoading = false;

  @override
  void initState() {
    super.initState();
    reportController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 64,
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CustomTextFieldWidget(
                controller: reportController,
                hintText: "Banın səbəbini daxil edin"),
          ),
          const SizedBox(
            height: 64,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomLoadingButton(
                onPressed: () {
                  if (!isReportLoading) {
                    setState(() {
                      isReportLoading = true;
                    });
                    context
                        .read<ChatPageCubit>()
                        .banUser(widget.username, reportController.text.trim(),
                            (success, message) {
                      setState(() {
                        isReportLoading = false;
                      });
                      showToastMessage(context, message);

                      if (success) {
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                isLoading: isReportLoading,
                text: "Göndər",
                color: const Color(goldColor),
                textColor: Colors.black),
          ),
          const SizedBox(
            height: 64,
          )
        ],
      ),
    );
  }
}
