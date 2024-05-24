import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import '../widgets/mao_jogador_widget.dart';
import '../widgets/CorrerButton.dart';
import '../widgets/TrucoButton.dart';
import '../widgets/scoreboard.dart'; // Importar o widget de pontuação

class JogoTrucoLayout extends StatelessWidget {
  final List<Jogador> jogadores;
  final int jogadorAtualIndex;
  final String resultadoRodada;
  final List<Carta> cartasJaJogadas;
  final Function(int) onCartaSelecionada;
  final Carta? manilha;
  final bool rodadacontinua;
  final List<Carta> cartas;

  JogoTrucoLayout({
    required this.jogadores,
    required this.jogadorAtualIndex,
    required this.resultadoRodada,
    required this.cartasJaJogadas,
    required this.onCartaSelecionada,
    this.manilha,
    required this.rodadacontinua,
    required this.cartas,
  });

  @override
  Widget build(BuildContext context) {
    int nos = jogadores[0].getPontuacaoTotal();
    int eles = jogadores[1].getPontuacaoTotal();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        elevation: 250,
        toolbarHeight: 100,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TRUCO', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            PontuacaoWidget(nos: nos, eles: eles), // Adicionar widget de pontuação
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/imgs/background.png', // Caminho para a imagem de fundo
              fit: BoxFit.cover,
            ),
          ),
          // Table
          Positioned(
            top: 120,  // Ajuste a posição vertical da mesa
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 400,
                color: Color.fromARGB(221, 30, 122, 2).withOpacity(0.8), 
                
                 // Cor de fundo com opacidade
                //borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  children: [
                    // Manilha no canto superior direito
                    if (manilha != null)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 90.0,  // Ajuste a largura da carta
                          height: 120.0,  // Ajuste a altura da carta
                          margin: const EdgeInsets.all(0.5), 
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(4.0),
                            child: Image.asset(manilha!.imagePath),
                          ),
                        ),
                      ),
                    // Cartas jogadas na mesa
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: cartasJaJogadas.map((carta) {
                            return Container(
                              margin: const EdgeInsets.all(4.0),
                              child: Image.asset(carta.imagePath, width: 70, height: 100),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Result
          // Positioned(
          //   top: 50,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: Text(
          //       resultadoRodada,
          //       style: TextStyle(
          //         fontSize: 24,
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          // Player Hands
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: jogadores[jogadorAtualIndex].mao.asMap().entries.map((entry) {
                  int index = entry.key;
                  Carta carta = entry.value;
                  return GestureDetector(
                    onTap: rodadacontinua ? () => onCartaSelecionada(index) : null,
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      child: Image.asset(carta.imagePath, width: 85, height: 135),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          //botões são usados
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TrucoButton(),
                  SizedBox(width: 50),  // Espaço entre os botões
                  CorrerButton(),
                ],
              ),
            ),
          ),
          // Messages: Jogador Atual and Resultado da Rodada
          Positioned(
            top: 20,
            left: 40,
            right: 40,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black87.withOpacity(0.1), // Cor de fundo com opacidade
                borderRadius: BorderRadius.circular(10.0), // Borda arredondada
              ),
              child: Column(
                children: [
                  Text(
                    'Jogador Atual: ${jogadores[jogadorAtualIndex].nome}',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

