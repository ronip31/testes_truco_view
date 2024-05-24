import 'package:flutter/material.dart';

class TrucoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.casino, color: Colors.black),
          SizedBox(width: 8),
          Text('TRUCO'),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 137, 238, 69),
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
