import 'package:flutter/material.dart';

class CorrerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.exit_to_app, color: Colors.red[900]),
          SizedBox(width: 10),
          Text('CORRER', style: TextStyle(color: Colors.red[900], fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 255, 255), 
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 0, 0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
      ),
    );
  }
}
