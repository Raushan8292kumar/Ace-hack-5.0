import 'package:flutter/material.dart';

bool islogin = false;

final OutlineInputBorder enableborder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(width: 2.5, color: Colors.grey.shade500),
);
final OutlineInputBorder focusborder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(width: 2.5, color: Colors.black),
);

final ButtonStyle buttonstyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.black,
  minimumSize: Size(double.infinity,65),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
);
final ButtonStyle styleButton = TextButton.styleFrom(
  minimumSize: Size(150, 20),
  backgroundColor: Colors.blueGrey.shade100,
);

final TextStyle buttontext = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.blue.shade900,
);
// {'code': 'en-IN', 'name': 'English (India)'},
//     {'code': 'en-US', 'name': 'English (US)'},