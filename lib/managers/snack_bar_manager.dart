import 'package:flutter/material.dart';

/// Convert to abstract manager
class SnackBarManager {
  static showErrorSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text('123'),
      action: SnackBarAction(
        textColor: Colors.black,
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
