import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'player_screen.dart';

class GameScreen extends StatefulWidget {
  final String roomId;
  final String playerName;

  const GameScreen({super.key, required this.roomId, required this.playerName});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? opponentName;
  bool bothPlayersReady = false;
  int? playerId;

  @override
  void initState() {
    super.initState();
    _checkOpponent();
  }

  void _checkOpponent() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId);
    roomRef.snapshots().listen((snapshot) {
      if (snapshot.exists && mounted) {
        final data = snapshot.data()!;
        final List<dynamic> players = data['players'];
        if (players.length == 2) {
          setState(() {
            opponentName = players.firstWhere((name) => name != widget.playerName);
            playerId = players.indexOf(widget.playerName) + 1;
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
        builder: (context) => PlayerScreen(roomId: widget.roomId, playerName: widget.playerName),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Jogo - ${widget.roomId}'),
    ),
    body: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[800]!, Colors.green[200]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: bothPlayersReady
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Seu oponente é: $opponentName',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber, // Botão com cor destacada
                      foregroundColor: Colors.black, // Cor do texto do botão
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'COMEÇAR!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    'Aguardando oponente...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}

}
