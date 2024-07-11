import 'package:flutter/material.dart';

class RoundIndicator extends StatelessWidget {
  // Lista de cores que representam o estado das rodadas
  final List<Color> colors;

  // Construtor que inicializa a lista de cores
  const RoundIndicator({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centraliza os widgets filhos na linha
      children: List.generate(3, (index) {
        return Column(
          children: [
            Container(
              width: 15, // Largura do indicador de rodada
              height: 12, // Altura do indicador de rodada
              margin: const EdgeInsets.all(2), // Espaço ao redor de cada indicador
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Forma do indicador (círculo)
                color: index < colors.length ? colors[index] : Colors.grey, // Cor do indicador
                border: Border.all(color: Colors.black, width: 1.2), // Borda preta ao redor do indicador
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Cor da sombra (preta com 20% de opacidade)
                    spreadRadius: 2, // Expansão da sombra
                    blurRadius: 10, // Desfoque da sombra
                    offset: const Offset(0, 1), // Deslocamento da sombra
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
