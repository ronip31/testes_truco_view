import 'package:flutter/material.dart';
import '../interface_user/room_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _playerNameController = TextEditingController();

  void _goToRoomSelection() {
    final playerName = _playerNameController.text;
    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu nome')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRUCO ROYALE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Insira seu nome para começar',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _playerNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome do Jogador',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _goToRoomSelection,
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
