import 'package:flutter/material.dart';

class PlayerNameForm extends StatelessWidget {
  final TextEditingController controller;

  const PlayerNameForm({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nome do Jogador',
        ),
      ),
    );
  }
}