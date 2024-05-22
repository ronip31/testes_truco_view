import 'package:flutter/material.dart';
import '../models/carta.dart';
import 'carta_widget.dart';

class MaoJogadorWidget extends StatelessWidget {
  final List<Carta> mao;
  final Function(int) onCartaSelecionada;
  final List<Carta> cartasJaJogadas;

  MaoJogadorWidget({
    required this.mao,
    required this.onCartaSelecionada,
    required this.cartasJaJogadas,
  });

  @override
  Widget build(BuildContext context) {
    print('MaoJogadorWidget');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: mao.asMap().entries.map((entry) {
        final index = entry.key;
        final carta = entry.value;
        final jaJogada = cartasJaJogadas.contains(carta); // Verifica se a carta já foi jogada

        return GestureDetector(
          onTap: () {
            if (!jaJogada) {
              onCartaSelecionada(index); // Passa o índice correto da carta na mão
              print('Índice da carta selecionada: $index');
            }
          },
          child: CartaWidget(
            carta: carta,
            onTap: () {
              if (!jaJogada) {
                onCartaSelecionada(index); // Passa o índice correto da carta na mão
                print('Índice da carta selecionada: $carta');
              }
            },
            disabled: jaJogada,
          ),
        );
      }).toList(),
    );
  }
}
