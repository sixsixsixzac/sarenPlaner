import 'package:flutter/material.dart';

void navigateTo({
  required BuildContext context,
  required Widget toPage,
  bool replace = false,
}) {
  final route = MaterialPageRoute(builder: (context) => toPage);

  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}
