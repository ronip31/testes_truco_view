import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_state.dart';  // Certifique-se de importar corretamente

class GameScreen extends StatefulWidget {
  final String roomId;
  final String playerName;

  const GameScreen({Key? key, required this.roomId, required this.playerName}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? opponentName;
  bool bothPlayersReady = false;

  @override
  void initState() {
    super.initState();
    _checkOpponent();
  }

  void _checkOpponent() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId);
    roomRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final List<dynamic> players = data['players'];
        if (players.length == 2) {
          setState(() {
            opponentName = players.firstWhere((name) => name != widget.playerName);
            bothPlayersReady = true;
          });
        }
      }
    });
  }

  void _startGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => JogoTrucoScreen(roomId: widget.roomId, playerName: widget.playerName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo - ${widget.roomId}'),
      ),
      body: Center(
        child: bothPlayersReady
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Seu oponente é: $opponentName'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startGame,
                    child: const Text('COMEÇAR!'),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
