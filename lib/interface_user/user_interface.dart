import 'package:flutter/material.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import '../widgets/esconder_button.dart';
import '../widgets/truco_button.dart';
import '../widgets/scoreboard.dart';
import '../controls/pedir_truco.dart';
import '../controls/truco_manager.dart';

// Classe principal do layout do jogo de truco
class JogoTrucoLayout extends StatefulWidget {
  final List<Jogador> jogadores; // Lista de jogadores
  final int jogadorAtualIndex; // Índice do jogador atual
  final String resultadoRodada; // Resultado da rodada atual
  final List<Carta> cartasJaJogadas; // Cartas já jogadas na mesa
  final Function(int) onCartaSelecionada; // Função callback para selecionar carta
  final Carta? manilha; // Carta manilha
  final bool rodadacontinua; // Indica se a rodada continua

  const JogoTrucoLayout({
    super.key,
    required this.jogadores,
    required this.jogadorAtualIndex,
    required this.resultadoRodada,
    required this.cartasJaJogadas,
    required this.onCartaSelecionada,
    this.manilha,
    required this.rodadacontinua,
  });

  @override
  JogoTrucoLayoutState createState() => JogoTrucoLayoutState();
}

// Classe de estado do layout do jogo de truco
class JogoTrucoLayoutState extends State<JogoTrucoLayout> {
  Truco truco = Truco(); // Instância da classe Truco
  final TrucoManager trucoManager = TrucoManager(); // Instância da classe TrucoManager

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // Constroi a AppBar
      body: Stack(
        children: [
          _buildBackground(), // Constroi o fundo do jogo
          _buildTable(), // Constroi a mesa do jogo
          _buildPlayerHands(), // Constroi as mãos dos jogadores
          _buildActionButtons(context), // Constroi os botões de ação
          _buildTopInfo(), // Constroi as informações do topo
        ],
      ),
    );
  }

  // Método para construir a AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.green[800], // Cor de fundo
      elevation: 5,
      toolbarHeight: 100, // Altura da AppBar
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('TRUCO ROYALE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 212, 177, 18))),
          const SizedBox(height: 10),
          // Widget de pontuação
          PontuacaoWidget(nos: widget.jogadores[0].pontuacao.getPontuacaoTotal(), eles: widget.jogadores[1].pontuacao.getPontuacaoTotal()),
        ],
      ),
      centerTitle: true,
    );
  }

  // Método para construir o fundo do jogo
  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/imgs/background.png',
        fit: BoxFit.cover,
      ),
    );
  }

  // Método para construir a mesa do jogo
  Widget _buildTable() {
    return Positioned(
      top: 120,
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
              if (widget.manilha != null) _buildManilha(), // Constroi a manilha se ela existir
              _buildPlayedCards(), // Constroi as cartas jogadas
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir a carta manilha
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
          child: Image.asset(widget.manilha!.img), // Imagem da carta manilha
        ),
      ),
    );
  }

  // Método para construir as cartas jogadas na mesa
  Widget _buildPlayedCards() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.cartasJaJogadas.map((carta) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              child: Image.asset(carta.img, width: 70, height: 100), // Imagem da carta jogada
            );
          }).toList(),
        ),
      ),
    );
  }

  // Método para construir as mãos dos jogadores
  Widget _buildPlayerHands() {
    return Positioned(
      bottom: 70,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.jogadores[widget.jogadorAtualIndex].mao.asMap().entries.map((entry) {
            int index = entry.key;
            Carta carta = entry.value;
            bool cartaJaJogada = widget.cartasJaJogadas.contains(carta);

            return GestureDetector(
              onTap: widget.rodadacontinua && !cartaJaJogada ? () => widget.onCartaSelecionada(index) : null, // Ação ao selecionar carta
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: cartaJaJogada ? Colors.grey : Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.asset(carta.img, width: 92, height: 135, fit: BoxFit.cover), // Imagem da carta na mão do jogador
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Método para construir os botões de ação (Truco e Correr)
  Widget _buildActionButtons(BuildContext context) {
    return Positioned(
      bottom: 25,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botão Truco
            TrucoButton(onPressed: () => trucoManager.onTrucoButtonPressed(context, widget.jogadores[widget.jogadorAtualIndex], widget.jogadores, widget.jogadorAtualIndex)),
            const SizedBox(width: 50),
            // Botão Correr
            const CorrerButton(),
          ],
        ),
      ),
    );
  }

  // Método para construir as informações do topo (jogador atual)
  Widget _buildTopInfo() {
    return Positioned(
      top: 20,
      left: 40,
      right: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              'Jogador Atual: ${widget.jogadores[widget.jogadorAtualIndex].nome}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
