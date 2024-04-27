import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomSnackbar(BuildContext context, String message) {
  if(message!="") {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

void showToastMessage(BuildContext context, String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
