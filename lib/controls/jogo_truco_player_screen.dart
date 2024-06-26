import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import '../controls/game_logic.dart';
import 'firebase_service.dart';
import 'package:tuple/tuple.dart';
import '../models/baralho.dart';

abstract class JogoTrucoPlayerScreen extends StatefulWidget {
  final String roomId;
  final String playerName;

  const JogoTrucoPlayerScreen({Key? key, required this.roomId, required this.playerName}) : super(key: key);

  @override
  JogoTrucoPlayerScreenState createState();
}

abstract class JogoTrucoPlayerScreenState<T extends JogoTrucoPlayerScreen> extends State<T> {
  List<Jogador> jogadores = [];
  bool gameReady = false;
  late Jogador jogadorAtual;
  late FirebaseService firebaseService;
  late GameLogic gameLogic;
  bool gameStateLoaded = false;
  StreamSubscription<DocumentSnapshot>? roomSubscription;
  Carta? manilha;

  @override
  void initState() {
    super.initState();
    firebaseService = FirebaseService(widget.roomId);
    _initializeGame();
  }

  @override
  void dispose() {
    roomSubscription?.cancel();
    super.dispose();
  }

  void _initializeGame() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId);

    roomSubscription = roomRef.snapshots().listen((snapshot) {
      if (snapshot.exists && mounted) {
        final data = snapshot.data() as Map<String, dynamic>;
        final List<dynamic>? players = data['players'];
        if (players != null && players.length == 2 && jogadores.isEmpty) {
          jogadores = Jogador.criarJogadores(players.cast<String>(), 2);
          jogadorAtual = jogadores.firstWhere((jogador) => jogador.nome == widget.playerName);
          gameLogic = GameLogic(firebaseService, jogadores);
          if (players[0] == widget.playerName && data['gameState'] == null) {
            _distributeCards();
          } else if (!gameStateLoaded) {
            _loadGameState(data['gameState']);
          }
          if (mounted) {
            setState(() {});
          }
        } else if (data['gameState'] != null && !gameStateLoaded) {
          _loadGameState(data['gameState']);
        }
        if (data['mesaState'] != null) {
          _updateMesaState(data['mesaState']);
        }
      }
    });
  }

  void _distributeCards() async {
    final baralho = Baralho();
    baralho.embaralhar();
    final todasMaosJogadores = baralho.distribuirCartasParaJogadores(2);

    final cartasJogador1 = todasMaosJogadores[0].map((carta) => carta.toString()).toList();
    final cartasJogador2 = todasMaosJogadores[1].map((carta) => carta.toString()).toList();

    baralho.cartas[0].ehManilha = true;
    final manilhaGlobal = baralho.cartas.firstWhere((carta) => carta.ehManilha).toString();

    await firebaseService.distributeCards(cartasJogador1, cartasJogador2, manilhaGlobal).then((_) {
      if (mounted) {
        setState(() {
          gameReady = true;
        });
      }
    });
  }

  void _loadGameState(Map<String, dynamic>? gameState) {
    if (gameState != null && mounted) {
      setState(() {
        manilha = Carta.fromString(gameState['manilha']);
        if (jogadorAtual.playerId == 1) {
          jogadorAtual.mao = (gameState['cartasJogador1'] as List).map((cartaMap) => Carta.fromString(cartaMap)).toList();
        } else if (jogadorAtual.playerId == 2) {
          jogadorAtual.mao = (gameState['cartasJogador2'] as List).map((cartaMap) => Carta.fromString(cartaMap)).toList();
        }
        gameReady = true;
        gameStateLoaded = true;
      });
    }
  }

  void _updateMesaState(Map<String, dynamic> mesaState) {
    if (!mounted) return;
    setState(() {
      gameLogic.cartasJogadasNaMesa = (mesaState['cartasJogadasNaMesa'] as List).map((cartaMap) {
        final jogador = jogadores.firstWhere((jogador) => jogador.nome == cartaMap['jogador']);
        return Tuple2(
          jogador,
          {
            'carta': Carta.fromString(cartaMap['carta']),
            'valor': cartaMap['valor']
          }
        );
      }).toList();
    });
  }


  void jogarCarta(Carta carta) {
  print('jogarCarta do JogoTrucoPlayerScreen');
  gameLogic.jogarCarta(carta, context);
}


  @override
  Widget build(BuildContext context);
}
