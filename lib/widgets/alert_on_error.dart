import 'package:flutter/material.dart';

class ShowAlertOnError {
  static Future<void> showAlertOnError(
      BuildContext context, String text) async {
    return await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Oops!'),
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('OK'))
            ],
          );
        });
  }
}
