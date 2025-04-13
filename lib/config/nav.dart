import 'package:flutter/material.dart';

class Nav {
  static push(BuildContext context, Widget page) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ));
  }

  static replace(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ));
  }
}
