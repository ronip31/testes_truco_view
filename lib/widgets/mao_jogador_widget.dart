import 'package:flutter/material.dart';
import '../models/carta.dart';

class MaoJogadorWidget extends StatelessWidget {
  final List<Carta> mao;
  final Function(int) onCartaSelecionada;
  final List<Carta> cartasJaJogadas;
  final bool rodadacontinua;

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: mao.asMap().entries.map((entry) {
        int idx = entry.key;
        Carta carta = entry.value;
        return GestureDetector(
          onTap: () {
            if (rodadacontinua && !cartasJaJogadas.contains(carta)) {
              onCartaSelecionada(idx);
            }
          },
          child: Container(
            width: 90.0,
            height: 120.0,
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: cartasJaJogadas.contains(carta) ? Colors.grey : Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: carta.img.isNotEmpty
              ? Image.asset(carta.img, fit: BoxFit.cover)
              : Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(carta.valor, style: const TextStyle(fontSize: 20.0)),
                      Text(carta.naipe, style: const TextStyle(fontSize: 16.0)),
                    ],
                  ),
                ),
          ),
        );
      }).toList(),
    );
  }
}
