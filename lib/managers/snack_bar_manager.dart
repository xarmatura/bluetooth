import 'package:flutter/material.dart';

/// Convert to abstract manager
class SnackBarManager {
  static showSnackBar(String message, GlobalKey<ScaffoldMessengerState> key, Color color) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(message),
      action: SnackBarAction(
        textColor: Colors.black,
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    key.currentState?.showSnackBar(snackBar);
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
