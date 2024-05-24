import 'package:flutter/material.dart';

class CorrerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.exit_to_app, color: Colors.white),
          SizedBox(width: 8),
          Text('CORRER', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 1, 1).withOpacity(0.6), 
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 0, 0, 0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
      ),
    );
  }
}
