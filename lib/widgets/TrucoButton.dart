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
          Icon(Icons.casino, color: Colors.black),
          SizedBox(width: 8),
          Text('TRUCO', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 137, 238, 69).withOpacity(0.7),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 20, color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
      ),
    );
  }
}
