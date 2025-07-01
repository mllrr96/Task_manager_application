import 'package:flutter/material.dart';

extension ScaffoldMessengerExtension on BuildContext {
  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: Theme.of(this).textTheme.bodyLarge,
      ),
      backgroundColor: Color(0xffC5292A),
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}
