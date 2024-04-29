import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void bottomShowToast(String toastMessage) {
  Fluttertoast.showToast(
    msg: toastMessage,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
    fontSize: 24.0,
  );
}

void topShowToast(String toastMessage) {
  Fluttertoast.showToast(
    msg: toastMessage,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
    fontSize: 24.0,
  );
}
