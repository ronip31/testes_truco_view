import 'dart:async'; // Importação necessária para StreamSubscription
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/playernameform.dart';
import '../controls/game_screen.dart';
import '../models/baralho.dart';

class RoomSelectionScreen extends StatefulWidget {
  const RoomSelectionScreen({super.key});

  @override
  _RoomSelectionScreenState createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends State<RoomSelectionScreen> {
  final TextEditingController _playerNameController = TextEditingController();
  String? _roomId;
  bool _waitingForOpponent = false;
  bool isServer = false;
  StreamSubscription<DocumentSnapshot>? roomSubscription; // Declaração da assinatura do stream

  @override
  void dispose() {
    roomSubscription?.cancel(); // Cancela qualquer assinatura existente
    super.dispose();
  }

  void _joinRoom(BuildContext context, String roomId) async {
    final playerName = _playerNameController.text;
    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu nome')),
      );
      return;
    }

    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      await roomRef.set({
        'players': [playerName],
        'gameState': {
          'currentPlayerId': 1, // Inicialize com o primeiro jogador
        },
      });
      isServer = true;
    } else {
      final data = roomSnapshot.data() as Map<String, dynamic>?;
      if (data == null || data['players'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar os dados da sala')),
        );
        return;
      }
      final players = List<String>.from(data['players']);
      if (players.length < 2) {
        players.add(playerName);
        await roomRef.update({'players': players});
        isServer = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sala cheia')),
        );
        return;
      }
    }

    setState(() {
      _roomId = roomId;
      _waitingForOpponent = true;
    });

    if (isServer) {
      _distributeCards(roomRef);
    }

    _waitForOpponent(roomRef, playerName);
  }

  void _distributeCards(DocumentReference roomRef) async {
    final baralho = Baralho();
    baralho.embaralhar();
    final todasMaosJogadores = baralho.distribuirCartasParaJogadores(2);

    final cartasJogador1 = todasMaosJogadores[0].map((carta) => carta.toString()).toList();
    final cartasJogador2 = todasMaosJogadores[1].map((carta) => carta.toString()).toList();

    baralho.cartas[0].ehManilha = true;
    final manilhaGlobal = baralho.cartas.firstWhere((carta) => carta.ehManilha).toString();

    await roomRef.update({
      'gameState': {
        'manilha': manilhaGlobal,
        'cartasJogador1': cartasJogador1,
        'cartasJogador2': cartasJogador2,
      }
    });
  }

  void _waitForOpponent(DocumentReference roomRef, String playerName) {
    roomSubscription?.cancel(); // Cancela qualquer assinatura existente
    roomSubscription = roomRef.snapshots().listen((roomSnapshot) {
      if (!mounted) return;

      if (roomSnapshot.exists) {
        final data = roomSnapshot.data() as Map<String, dynamic>;
        final players = List<String>.from(data['players']);
        if (players.length == 2 && players.contains(playerName)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(roomId: roomRef.id, playerName: playerName),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleção de Sala') ,
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
        child: Column(
          children: [
            const Text(
              'Bem-vindo ao Truco Royale!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            PlayerNameForm(controller: _playerNameController),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  final roomId = 'room${index + 1}';
                  return Card(
                    color: Colors.green[100],
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        'Sala ${index + 1}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _joinRoom(context, roomId),
                    ),
                  );
                },
              ),
            ),
            if (_waitingForOpponent)
              const Center(
                child: Column(
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
          ],
        ),
      ),
    );
  }
}
