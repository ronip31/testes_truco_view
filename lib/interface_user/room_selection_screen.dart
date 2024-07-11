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
  final TextEditingController _playerNameController = TextEditingController(); // Controlador de texto para o nome do jogador
  String? _roomId; // ID da sala que o jogador está tentando entrar
  bool _waitingForOpponent = false; // Indica se está aguardando um oponente
  bool isServer = false; // Indica se o jogador é o servidor (criador da sala)
  StreamSubscription<DocumentSnapshot>? roomSubscription; // Assinatura para ouvir mudanças na sala

  @override
  void dispose() {
    // Cancela qualquer assinatura existente quando o widget for descartado
    roomSubscription?.cancel();
    super.dispose();
  }

  // Função para o jogador se juntar a uma sala
  void _joinRoom(BuildContext context, String roomId) async {
    final playerName = _playerNameController.text;
    // Verifica se o nome do jogador foi inserido
    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu nome')),
      );
      return;
    }

    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final roomSnapshot = await roomRef.get();

    // Se a sala não existe, cria uma nova sala
    if (!roomSnapshot.exists) {
      await roomRef.set({
        'players': [playerName],
        'gameState': {
          'currentPlayerId': 1, // Inicializa com o primeiro jogador
        },
      });
      isServer = true; // Define o jogador como servidor
    } else {
      // Se a sala existe, adiciona o jogador à sala
      final data = roomSnapshot.data() as Map<String, dynamic>?;
      if (data == null || data['players'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar os dados da sala')),
        );
        return;
      }
      final players = List<String>.from(data['players']);
      // Verifica se a sala está cheia
      if (players.length < 2) {
        players.add(playerName);
        await roomRef.update({'players': players});
        isServer = false; // Define o jogador como cliente
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sala cheia')),
        );
        return;
      }
    }

    setState(() {
      _roomId = roomId;
      _waitingForOpponent = true; // Define que está aguardando um oponente
    });

    // Se o jogador é o servidor, distribui as cartas
    if (isServer) {
      _distributeCards(roomRef);
    }

    // Aguarda a entrada de um oponente
    _waitForOpponent(roomRef, playerName);
  }

  // Função para distribuir as cartas aos jogadores
  void _distributeCards(DocumentReference roomRef) async {
    final baralho = Baralho(); // Cria um novo baralho
    baralho.embaralhar(); // Embaralha o baralho
    final todasMaosJogadores = baralho.distribuirCartasParaJogadores(2); // Distribui as cartas para 2 jogadores

    // Converte as cartas para string para armazenar no Firebase
    final cartasJogador1 = todasMaosJogadores[0].map((carta) => carta.toString()).toList();
    final cartasJogador2 = todasMaosJogadores[1].map((carta) => carta.toString()).toList();

    // Define a primeira carta como manilha
    baralho.cartas[0].ehManilha = true;
    final manilhaGlobal = baralho.cartas.firstWhere((carta) => carta.ehManilha).toString();

    // Atualiza o estado do jogo no Firebase com as cartas distribuídas
    await roomRef.update({
      'gameState': {
        'manilha': manilhaGlobal,
        'cartasJogador1': cartasJogador1,
        'cartasJogador2': cartasJogador2,
      }
    });
  }

  // Função para aguardar a entrada de um oponente
  void _waitForOpponent(DocumentReference roomRef, String playerName) {
    roomSubscription?.cancel(); // Cancela qualquer assinatura existente
    roomSubscription = roomRef.snapshots().listen((roomSnapshot) {
      if (!mounted) return;

      if (roomSnapshot.exists) {
        final data = roomSnapshot.data() as Map<String, dynamic>;
        final players = List<String>.from(data['players']);
        // Se os dois jogadores estão na sala, navega para a tela do jogo
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
        title: const Text('Seleção de Sala'), // Título da aplicação
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
            PlayerNameForm(controller: _playerNameController), // Formulário para o jogador inserir o nome
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Número de salas disponíveis
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
                      onTap: () => _joinRoom(context, roomId), // Junta-se à sala quando clicada
                    ),
                  );
                },
              ),
            ),
            if (_waitingForOpponent)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(), // Indicador de progresso
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
