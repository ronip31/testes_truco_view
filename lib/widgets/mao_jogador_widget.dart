import 'package:flutter/material.dart';
import '../models/carta.dart';

class MaoJogadorWidget extends StatelessWidget {
  final List<Carta> mao; // Lista de cartas na mão do jogador
  final Function(int) onCartaSelecionada; // Função callback chamada quando uma carta é selecionada
  final List<Carta> cartasJaJogadas; // Lista de cartas já jogadas
  final bool rodadacontinua; // Indica se a rodada ainda está em andamento

  const MaoJogadorWidget({
    super.key,
    required this.mao,
    required this.onCartaSelecionada,
    required this.cartasJaJogadas,
    required this.rodadacontinua,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centraliza as cartas na linha
      children: mao.asMap().entries.map((entry) {
        int idx = entry.key; // Índice da carta na lista
        Carta carta = entry.value; // Objeto Carta

        return GestureDetector(
          onTap: () {
            // Verifica se a rodada continua e se a carta ainda não foi jogada
            if (rodadacontinua && !cartasJaJogadas.contains(carta)) {
              onCartaSelecionada(idx); // Chama a função de seleção da carta
            }
          },
          child: Container(
            width: 90.0,
            height: 120.0,
            margin: const EdgeInsets.all(4.0), // Margem ao redor de cada carta
            decoration: BoxDecoration(
              color: cartasJaJogadas.contains(carta) ? Colors.grey : Colors.white, // Cor da carta (cinza se já jogada)
              border: Border.all(color: Colors.black), // Borda preta ao redor da carta
              borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
            ),
            child: carta.img.isNotEmpty
              ? Image.asset(carta.img, fit: BoxFit.cover) // Imagem da carta
              : Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centraliza o texto dentro do Card
                    children: [
                      Text(carta.valor, style: const TextStyle(fontSize: 20.0)), // Texto do valor da carta
                      Text(carta.naipe, style: const TextStyle(fontSize: 16.0)), // Texto do naipe da carta
                    ],
                  ),
                ),
          ),
        );
      }).toList(),
    );
  }
}
