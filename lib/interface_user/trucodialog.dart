import 'package:flutter/material.dart';

class TrucoDialog {
  static Future<String?> showTrucoDialog(
      BuildContext context, String title, String message, List<String> options) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              for (int i = 0; i < options.length; i++)
                ListTile(
                  title: Text(options[i]),
                  onTap: () => Navigator.of(context).pop('$i'),
                ),
            ],
          ),
        );
      },
    );
  }
}
