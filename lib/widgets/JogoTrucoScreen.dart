import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import '../widgets/mao_jogador_widget.dart';

class JogoTrucoLayout extends StatelessWidget {
  final List<Jogador> jogadores;
  final int jogadorAtualIndex;
  final String resultadoRodada;
  final List<Carta> cartasJaJogadas;
  final Function(int) onCartaSelecionada;
  final Carta? manilha;

  JogoTrucoLayout({
    required this.jogadores,
    required this.jogadorAtualIndex,
    required this.resultadoRodada,
    required this.cartasJaJogadas,
    required this.onCartaSelecionada,
    this.manilha,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo de Truco'),
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              color: Colors.brown[700],
            ),
          ),
          // Table
          Center(
            child: Container(
              width: 300,
              height: 400,
              color: Colors.green[800],
              child: Stack(
                children: [
                  // Manilha no canto superior direito
                  if (manilha != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 80.0,  // Ajuste a largura da carta
                        height: 100.0,  // Ajuste a altura da carta
                        margin: const EdgeInsets.all(0.5), 
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(manilha!.valor, style: TextStyle(fontSize: 20.0)),
                              Text(manilha!.naipe, style: TextStyle(fontSize: 16.0)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Player's hand below the table
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaoJogadorWidget(
                  mao: jogadores[jogadorAtualIndex].mao,
                  onCartaSelecionada: onCartaSelecionada,
                  cartasJaJogadas: cartasJaJogadas,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TrucoButton(),
                    SizedBox(width: 20),
                    CorrerButton(),
                  ],
                ),
              ],
            ),
          ),
          // Messages: Jogador Atual and Resultado da Rodada
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black87.withOpacity(0.7), // Cor de fundo com opacidade
                borderRadius: BorderRadius.circular(10.0), // Borda arredondada
              ),
              child: Column(
                children: [
                  Text(
                    'Jogador Atual: ${jogadores[jogadorAtualIndex].nome}',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    resultadoRodada,
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrucoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text('TRUCO'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 20),
      ),
    );
  }
}

class CorrerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text('CORRER'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 20),
      ),
    );
  }
}
