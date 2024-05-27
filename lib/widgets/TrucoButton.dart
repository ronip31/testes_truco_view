import 'package:flutter/material.dart';

class TrucoButton extends StatelessWidget {
  final VoidCallback onPressed;

  TrucoButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.casino, color: Colors.green[900]),
          SizedBox(width: 8),
          Text('TRUCO', style: TextStyle(color: Colors.green[900], fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 20, color: Colors.green[900]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
      ),
    );
  }
}
