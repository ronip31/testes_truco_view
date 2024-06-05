import 'package:flutter/material.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import 'esconder_button.dart';
import 'truco_button.dart';
import '../widgets/scoreboard.dart';
import '../controls/pedir_truco.dart';
import '../controls/truco_manager.dart';

class JogoTrucoLayout extends StatefulWidget {
  final List<Jogador> jogadores;
  final int jogadorAtualIndex;
  final String resultadoRodada;
  final List<Carta> cartasJaJogadas;
  final Function(int) onCartaSelecionada;
  final Carta? manilha;
  final bool rodadacontinua;

  

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

class JogoTrucoLayoutState extends State<JogoTrucoLayout> {
  Truco truco = Truco();
  final TrucoManager trucoManager = TrucoManager(); // Instancia a nova classe


  

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
      toolbarHeight: 100,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('TRUCO ROYALE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 212, 177, 18))),
          const SizedBox(height: 10),
          PontuacaoWidget(nos: widget.jogadores[0].getPontuacaoTotal(), eles: widget.jogadores[1].getPontuacaoTotal()),
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
              if (widget.manilha != null) _buildManilha(),
              _buildPlayedCards(),
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
          child: Image.asset(widget.manilha!.img),
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
          children: widget.cartasJaJogadas.map((carta) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              child: Image.asset(carta.img, width: 70, height: 100),
            );
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
          children: widget.jogadores[widget.jogadorAtualIndex].mao.asMap().entries.map((entry) {
            int index = entry.key;
            Carta carta = entry.value;
            bool cartaJaJogada = widget.cartasJaJogadas.contains(carta);

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

  Widget _buildActionButtons(BuildContext context) {
    return Positioned(
      bottom: 25,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TrucoButton(onPressed: () => trucoManager.onTrucoButtonPressed(context, widget.jogadores[widget.jogadorAtualIndex], widget.jogadores, widget.jogadorAtualIndex)),
            const SizedBox(width: 50),
            const CorrerButton(),
          ],
        ),
      ),
    );
  }

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
