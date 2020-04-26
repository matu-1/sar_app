import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String getFechaActual() {
  var now = new DateTime.now();
  var formatter = new DateFormat("yyyy-MM-dd");
  String formattedDate = formatter.format(now);
  print(formattedDate); // 2016-01-25
  return formattedDate;
}

void mensajeToast(String mensaje) {
  Fluttertoast.showToast(
    msg: mensaje,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0
  );
}