import 'package:flutter/material.dart';

class CorrerButton extends StatelessWidget {
  final VoidCallback onEsconderPressed;

  const CorrerButton({super.key, required this.onEsconderPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onEsconderPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 0, 0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.exit_to_app, color: Colors.red[900]),
          const SizedBox(width: 10),
          Text(
            'ESCONDER',
            style: TextStyle(
              color: Colors.red[900],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
