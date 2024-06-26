import 'package:flutter/material.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import '../widgets/esconder_button.dart';
import '../widgets/truco_button.dart';
import '../widgets/scoreboard.dart';
import 'package:tuple/tuple.dart';
import '../controls/truco_manager.dart';
import '../controls/score_manager.dart';

class JogoTrucoLayout extends StatelessWidget {
  final Jogador jogadorAtual;
  final String resultadoRodada;
  final List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa; // Alteração aqui
  final Function(int) onCartaSelecionada;
  final Carta? manilha;
  final bool rodadacontinua;
  final Pontuacao pontuacao;
  final VoidCallback onEsconderPressed;
  final TrucoManager trucoManager = TrucoManager();

  JogoTrucoLayout({
    Key? key,
    required this.jogadorAtual,
    required this.resultadoRodada,
    required this.cartasJogadasNaMesa, // Alteração aqui
    required this.onCartaSelecionada,
    this.manilha,
    required this.rodadacontinua,
    required this.pontuacao,
    required this.onEsconderPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBackground(),
          _buildTable(),
          _buildPlayerHands(),
          _buildActionButtons(context),
          _buildTopInfo(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.green[800],
      elevation: 5,
      toolbarHeight: 120,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('TRUCO ROYALE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 212, 177, 18))),
          const SizedBox(height: 10),
          PontuacaoWidget(
            key: ValueKey(pontuacao.getResultadosRodadas().toString()),
            nos: pontuacao.getPontuacaoTotal(),
            eles: pontuacao.getPontuacaoTotal(),  // Atualize conforme a lógica de pontuação do adversário
            roundResults: pontuacao.getResultadosRodadas(),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/imgs/background.png',
        fit: BoxFit.cover,
      ),
    );
  }

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
              if (manilha != null) _buildManilha(),
              _buildPlayedCards(), // Alteração aqui
            ],
          ),
        ),
      ),
    );
  }

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
          child: Image.asset(manilha!.img),
        ),
      ),
    );
  }

  Widget _buildPlayedCards() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cartasJogadasNaMesa.where((tuple) => tuple != null).map((tuple) {
            final carta = tuple?.item2['carta'] as Carta?;
            if (carta != null) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                child: Image.asset(carta.img, width: 70, height: 100),
              );
            } else {
              return Container(); // Retorna um container vazio se carta for nula
            }
          }).toList(),
        ),
      ),
    );
  }



  Widget _buildPlayerHands() {
  return Positioned(
    bottom: 70,
    left: 0,
    right: 0,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: jogadorAtual.mao.asMap().entries.map((entry) {
          int index = entry.key;
          Carta carta = entry.value;
          bool cartaJaJogada = cartasJogadasNaMesa.any((tuple) {
            final cartaJogada = tuple?.item2['carta'] as Carta?;
            return cartaJogada == carta;
          });

          return GestureDetector(
            onTap: rodadacontinua && !cartaJaJogada ? () => onCartaSelecionada(index) : null,
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



  Widget _buildActionButtons(BuildContext context) {
    return Positioned(
      bottom: 25,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TrucoButton(onPressed: () => trucoManager.onTrucoButtonPressed(context, jogadorAtual, [jogadorAtual], 0)),  // Ajuste conforme a lógica de truco
            const SizedBox(width: 50),
            CorrerButton(
              onEsconderPressed: onEsconderPressed,
            ),
          ],
        ),
      ),
    );
  }

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
            Text(
              'Jogador Atual: ${jogadorAtual.nome}',
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
