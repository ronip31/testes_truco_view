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
  String? opponentName; // Nome do oponente
  bool bothPlayersReady = false; // Indica se ambos os jogadores estão prontos
  int? playerId; // ID do jogador

  @override
  void initState() {
    super.initState();
    _checkOpponent(); // Verifica se o oponente entrou na sala
  }

  // Função para verificar se o oponente entrou na sala
  void _checkOpponent() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId);
    roomRef.snapshots().listen((snapshot) {
      if (snapshot.exists && mounted) {
        final data = snapshot.data()!;
        final List<dynamic> players = data['players'];
        if (players.length == 2) {
          setState(() {
            // Define o nome do oponente
            opponentName = players.firstWhere((name) => name != widget.playerName);
            // Define o ID do jogador
            playerId = players.indexOf(widget.playerName) + 1;
            bothPlayersReady = true; // Ambos os jogadores estão prontos
          });
        }
      }
    });
  }

  // Função para iniciar o jogo
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
        title: Text('Jogo - ${widget.roomId}'), // Título da barra de aplicativos
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
                      'Seu oponente é: $opponentName', // Exibe o nome do oponente
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _startGame, // Chama a função para iniciar o jogo
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber, // Cor do botão
                        foregroundColor: Colors.black, // Cor do texto do botão
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'COMEÇAR!', // Texto do botão
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
                    CircularProgressIndicator(), // Indicador de progresso enquanto espera o oponente
                    SizedBox(height: 10),
                    Text(
                      'Aguardando oponente...', // Mensagem de espera
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
