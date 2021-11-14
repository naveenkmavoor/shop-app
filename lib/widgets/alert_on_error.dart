import 'package:flutter/material.dart';

class ShowAlertOnError {
  static Future<void> showAlertOnError(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Oops!'),
            content: Text('Somthing went wrong'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('OK'))
            ],
          );
        });
  }
}
