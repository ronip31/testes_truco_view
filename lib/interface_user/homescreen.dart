import 'package:flutter/material.dart';
import '../interface_user/room_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _playerNameController = TextEditingController(); // Controlador de texto para o nome do jogador

  // Função para navegar para a tela de seleção de sala
  void _goToRoomSelection() {
    final playerName = _playerNameController.text;
    // Verifica se o nome do jogador foi inserido
    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu nome')), // Mostra uma mensagem de erro se o nome estiver vazio
      );
      return;
    }

    // Navega para a tela de seleção de sala
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomSelectionScreen(), // Cria a rota para a tela de seleção de sala
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRUCO ROYALE'), // Título do aplicativo na barra de app
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza os filhos verticalmente
          children: [
            const Text(
              'Insira seu nome para começar',
              style: TextStyle(fontSize: 24), // Estilo do texto de instrução
            ),
            const SizedBox(height: 16), // Espaço vertical entre os widgets
            TextField(
              controller: _playerNameController, // Controlador para capturar o nome do jogador
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome do Jogador', // Texto de label para o campo de texto
              ),
            ),
            const SizedBox(height: 16), // Espaço vertical entre os widgets
            ElevatedButton(
              onPressed: _goToRoomSelection, // Ação do botão que chama a função para navegar
              child: const Text('Entrar'), // Texto do botão
            ),
          ],
        ),
      ),
    );
  }
}
