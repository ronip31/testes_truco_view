import 'package:flutter/material.dart';

class PlayerNameForm extends StatelessWidget {
  // Controlador de texto para o campo de entrada do nome do jogador
  final TextEditingController controller;

  // Construtor que inicializa o controlador de texto
  const PlayerNameForm({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Padding ao redor do TextField
      child: TextField(
        controller: controller, // Controlador de texto fornecido pelo usuário
        decoration: const InputDecoration(
          border: OutlineInputBorder(), // Borda do campo de entrada
          labelText: 'Nome do Jogador', // Rótulo dentro do campo de entrada
        ),
      ),
    );
  }
}
