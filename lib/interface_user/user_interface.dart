import 'package:flutter/material.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import '../widgets/esconder_button.dart';
import '../widgets/truco_button.dart';
import '../widgets/scoreboard.dart';
import 'package:tuple/tuple.dart';
import '../controls/truco_manager.dart';
import '../controls/score_manager.dart';
import '../controls/game_logic.dart';
import '../controls/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JogoTrucoLayout extends StatefulWidget {
  final Jogador jogadorAtual; // Jogador atual
  final GameLogic gameLogic; // Lógica do jogo
  final String resultadoRodada; // Resultado da rodada
  final List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa; // Cartas jogadas na mesa
  final Function(int) onCartaSelecionada; // Função chamada ao selecionar uma carta
  final Carta? manilha; // Carta manilha
  final bool rodadacontinua; // Indicador se a rodada continua
  final Pontuacao pontuacao; // Pontuação do jogo
  final VoidCallback onEsconderPressed; // Callback quando o botão de esconder é pressionado
  final TrucoManager trucoManager = TrucoManager(); // Gerenciador de truco
  final FirebaseService firebaseService; // Serviço Firebase
  final List<Jogador> jogadores; // Lista de jogadores

  JogoTrucoLayout({
    super.key,
    required this.jogadorAtual,
    required this.gameLogic,
    required this.resultadoRodada,
    required this.cartasJogadasNaMesa,
    required this.onCartaSelecionada,
    this.manilha,
    required this.rodadacontinua,
    required this.pontuacao,
    required this.onEsconderPressed,
    required this.firebaseService,
    required this.jogadores,
  });

  @override
  _JogoTrucoLayoutState createState() => _JogoTrucoLayoutState();
}

class _JogoTrucoLayoutState extends State<JogoTrucoLayout> {
  @override
  void initState() {
    super.initState();
    widget.gameLogic.addListener(_updateState); // Adiciona um listener para atualizações do estado do jogo
  }

  @override
  void dispose() {
    widget.gameLogic.removeListener(_updateState); // Remove o listener ao descartar o widget
    super.dispose();
  }

  // Função chamada para atualizar o estado do widget
  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // Constrói a barra de app
      body: Stack(
        children: [
          _buildBackground(), // Constrói o fundo
          _buildTable(), // Constrói a mesa de jogo
          _buildPlayerHands(), // Constrói as mãos dos jogadores
          _buildActionButtons(context), // Constrói os botões de ação
          _buildTopInfo(), // Constrói a informação do topo
        ],
      ),
    );
  }

  // Constrói a barra de app
  AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.green[800],
    elevation: 5,
    toolbarHeight: 120,
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'TRUCO ROYALE',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 212, 177, 18),
          ),
        ),
        const SizedBox(height: 10),
        StreamBuilder<DocumentSnapshot>(
          stream: widget.firebaseService.getGameStateStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data != null && data['gameState'] != null) {
                var roundResults = data['gameState']['roundResults'] as List<dynamic>? ?? [];
                var nos = data['gameState']['nos'] ?? 0;
                var eles = data['gameState']['eles'] ?? 0;

                return PontuacaoWidget(
                  key: ValueKey(roundResults.toString()),
                  roomId: widget.firebaseService.roomId, // Adiciona roomId para buscar dados do Firebase
                  nos: nos,
                  eles: eles,
                  roundResults: roundResults.cast<int>(),
                );
              }
            }
            return const PontuacaoWidget(
              key: ValueKey('loading'),
              roomId: '', // Define um valor padrão ou vazio para roomId
              nos: 0,
              eles: 0,
              roundResults: [],
            );
          },
        ),
      ],
    ),
    centerTitle: true,
  );
}


  // Constrói o fundo da tela
  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/imgs/background.png',
        fit: BoxFit.cover,
      ),
    );
  }

  // Constrói a mesa de jogo
  Widget _buildTable() {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.green[700]!.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              if (widget.manilha != null) _buildManilha(), // Constrói a carta manilha se existir
              _buildPlayedCards(), // Constrói as cartas jogadas
            ],
          ),
        ),
      ),
    );
  }

  // Constrói a carta manilha
  Widget _buildManilha() {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        width: 90,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(widget.manilha!.img),
        ),
      ),
    );
  }

  // Constrói as cartas jogadas na mesa
  Widget _buildPlayedCards() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: widget.firebaseService.getGameStateStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data != null && data['gameState'] != null) {
                var cartasNaMesa = data['gameState']['cartasJogadasNaMesa'] as List<dynamic>? ?? [];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: cartasNaMesa.map((cartaData) {
                    var carta = Carta.fromString(cartaData['carta']);
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      child: Image.asset(carta.img, width: 70, height: 100),
                    );
                  }).toList(),
                );
              }
            }
            return Container(); // Retorna um container vazio se os dados não estiverem prontos
          },
        ),
      ),
    );
  }

  // Constrói as mãos dos jogadores
  Widget _buildPlayerHands() {
    return Positioned(
      bottom: 70,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.jogadorAtual.mao.asMap().entries.map((entry) {
            int index = entry.key;
            Carta carta = entry.value;
            bool cartaJaJogada = widget.cartasJogadasNaMesa.any((tuple) {
              final cartaJogada = tuple.item2['carta'] as Carta?;
              return cartaJogada == carta;
            });

            return GestureDetector(
              onTap: widget.rodadacontinua && !cartaJaJogada ? () => widget.onCartaSelecionada(index) : null,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: cartaJaJogada ? Colors.grey : Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.asset(carta.img, width: 92, height: 135, fit: BoxFit.cover),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Constrói os botões de ação
  Widget _buildActionButtons(BuildContext context) {
    return Positioned(
      bottom: 25,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TrucoButton(onPressed: () => widget.trucoManager.onTrucoButtonPressed(context, widget.jogadorAtual, [widget.jogadorAtual], 0)),  // Ajuste conforme a lógica de truco
            const SizedBox(width: 50),
            CorrerButton(
              onEsconderPressed: widget.onEsconderPressed,
            ),
          ],
        ),
      ),
    );
  }

  // Constrói as informações do topo
  Widget _buildTopInfo() {
    return Positioned(
      top: 10,
      left: 40,
      right: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: widget.firebaseService.getGameStateStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var data = snapshot.data!.data() as Map<String, dynamic>?;
                  if (data != null && data['gameState'] != null) {
                    var currentPlayerId = data['gameState']['currentPlayerId'];
                    var currentPlayer = widget.jogadores.firstWhere((jogador) => jogador.playerId == currentPlayerId, orElse: () => widget.jogadores[0]);
                    return Text(
                      'Jogador Atual: ${currentPlayer.nome}',
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    );
                  }
                }
                return const Text(
                  'Carregando...',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                );
              },
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
