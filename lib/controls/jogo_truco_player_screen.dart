import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import '../controls/game_logic.dart';
import 'firebase_service.dart';
import 'package:tuple/tuple.dart';
import '../models/baralho.dart';
import 'dart:async';
import 'turn_manager.dart';

abstract class JogoTrucoPlayerScreen extends StatefulWidget {
  final String roomId;
  final String playerName;

  const JogoTrucoPlayerScreen({super.key, required this.roomId, required this.playerName});

  @override
  JogoTrucoPlayerScreenState createState();
}

abstract class JogoTrucoPlayerScreenState<T extends JogoTrucoPlayerScreen> extends State<T> {
  List<Jogador> jogadores = [];
  bool gameReady = false;
  late Jogador jogadorAtual;
  late FirebaseService firebaseService;
  late GameLogic gameLogic;
  late TurnManager turnManager;
  bool gameStateLoaded = false;
  bool isReloading = false;
  StreamSubscription<DocumentSnapshot>? roomSubscription;
  Carta? manilha;
  int jogadorAtualIndex = 0;

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

  // Inicializa o jogo, configurando o listener para o Firebase
  void _initializeGame() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId);

    roomSubscription = roomRef.snapshots().listen((snapshot) {
      if (snapshot.exists && mounted) {
        final data = snapshot.data() as Map<String, dynamic>;
        final List<dynamic>? players = data['players'];

        // Se os jogadores não estão configurados, configura-os
        if (players != null && players.length == 2 && jogadores.isEmpty) {
          jogadores = Jogador.criarJogadores(players.cast<String>(), 2);
          jogadorAtual = jogadores.firstWhere((jogador) => jogador.nome == widget.playerName);
          gameLogic = GameLogic(firebaseService, jogadores);
          gameLogic.onReiniciarRodada = _reiniciarRodada;

          // Se o jogador atual é o servidor e o estado do jogo não está configurado, distribui as cartas
          if (players[0] == widget.playerName && data['gameState'] == null) {
            _distributeCards();
          } else if (!gameStateLoaded) {
            _loadGameState(data['gameState']);
          }

          if (mounted) {
            setState(() {
              gameReady = true;
            });
          }
        } else if (data['gameState'] != null && !gameStateLoaded) {
          _loadGameState(data['gameState']);
          if (mounted) {
            setState(() {
              gameReady = true;
            });
          }
        }

        // Atualiza o estado das cartas na mesa
        if (data['gameState'] != null) {
          _updateMesaState(data['gameState']);
        }
      }
    });
  }

  // Distribui as cartas para os jogadores e atualiza o estado do jogo no Firebase
  void _distributeCards() async {
    final baralho = Baralho();
    baralho.embaralhar();
    final todasMaosJogadores = baralho.distribuirCartasParaJogadores(2);

    final cartasJogador1 = todasMaosJogadores[0].map((carta) => carta.toString()).toList();
    final cartasJogador2 = todasMaosJogadores[1].map((carta) => carta.toString()).toList();

    baralho.cartas[0].ehManilha = true;
    final manilhaGlobal = baralho.cartas.firstWhere((carta) => carta.ehManilha).toString();

    print('Distribuindo cartas:');
    print('Jogador 1: $cartasJogador1');
    print('Jogador 2: $cartasJogador2');
    print('Manilha: $manilhaGlobal');

    await firebaseService.distributeCards(cartasJogador1, cartasJogador2, manilhaGlobal);
    _reloadGameState();
  }

  // Carrega o estado do jogo a partir do Firebase
  void _loadGameState(Map<String, dynamic>? gameState) {
    if (gameState != null && mounted) {
      print('Carregando estado do jogo: $gameState');
      setState(() {
        manilha = gameState['manilha'] != null ? Carta.fromString(gameState['manilha']) : null;
        print('Manilha carregada: $manilha');

        // Atualiza as mãos dos jogadores
        jogadores[0].mao = (gameState['cartasJogador1'] as List<dynamic>?)
            ?.map((cartaMap) => Carta.fromString(cartaMap as String))
            .toList() ?? [];
        jogadores[1].mao = (gameState['cartasJogador2'] as List<dynamic>?)
            ?.map((cartaMap) => Carta.fromString(cartaMap as String))
            .toList() ?? [];

        print('Mão do jogador 1: ${jogadores[0].mao}');
        print('Mão do jogador 2: ${jogadores[1].mao}');

        print('cartasJogador1 gameState: ${gameState['cartasJogador1']}');
        print('cartasJogador2 gameState: ${gameState['cartasJogador2']}');
        
        List<dynamic>? cartasJogador1 = gameState['cartasJogador1'] as List<dynamic>?;
        List<dynamic>? cartasJogador2 = gameState['cartasJogador2'] as List<dynamic>?;

        print('cartasJogador1 antes da conversão: $cartasJogador1');
        print('cartasJogador2 antes da conversão: $cartasJogador2');

        jogadores[0].mao = cartasJogador1?.map((cartaMap) => Carta.fromString(cartaMap as String)).toList() ?? [];
        jogadores[1].mao = cartasJogador2?.map((cartaMap) => Carta.fromString(cartaMap as String)).toList() ?? [];

        print('Mão do jogador 1 após conversão: ${jogadores[0].mao}');
        print('Mão do jogador 2 após conversão: ${jogadores[1].mao}');

        gameReady = true;
        gameStateLoaded = true;
      });
    }
  }

  // Recarrega o estado do jogo do Firebase
  void _reloadGameState() async {
    if (isReloading) return;
    setState(() {
      isReloading = true;
    });

    print('Recarregando estado do jogo...');
    final gameState = await firebaseService.loadGameState();
    if (gameState != null) {
      print('Estado do jogo recarregado: $gameState');
      _loadGameState(gameState);
    } else {
      print('Estado do jogo não encontrado!');
    }

    setState(() {
      isReloading = false;
    });
  }

  // Atualiza o estado das cartas na mesa
  void _updateMesaState(Map<String, dynamic> gameState) {
    if (!mounted) return;

    final List<dynamic>? cartasJogadasNaMesaList = gameState['cartasJogadasNaMesa'] as List<dynamic>?;

    if (cartasJogadasNaMesaList != null) {
      setState(() {
        gameLogic.cartasJogadasNaMesa = cartasJogadasNaMesaList.map((cartaMap) {
          final jogador = jogadores.firstWhere((jogador) => jogador.nome == cartaMap['jogador']);
          return Tuple2(
            jogador,
            {
              'carta': Carta.fromString(cartaMap['carta']),
              'valor': cartaMap['valor']
            }
          );
        }).toList();
        print('Cartas jogadas na mesa: ${gameLogic.cartasJogadasNaMesa}');
      });
    }
  }

  // Função chamada para jogar uma carta
  void jogarCarta(Carta carta) {
    print('Jogando carta: ${carta.toString()}');
    gameLogic.jogarCarta(carta, context);
  }

  // Reinicia a rodada distribuindo novas cartas
  void _reiniciarRodada() {
    print('Reiniciando rodada...');
    _distributeCards();
  }

  @override
  Widget build(BuildContext context);
}
