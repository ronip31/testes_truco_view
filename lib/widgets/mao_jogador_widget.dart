import 'package:flutter/material.dart';
import '../models/carta.dart';
import 'carta_widget.dart';

class MaoJogadorWidget extends StatelessWidget {
  final List<Carta> mao;
  final Function(int) onCartaSelecionada;

  MaoJogadorWidget({required this.mao, required this.onCartaSelecionada});
  
  @override
  Widget build(BuildContext context) {
    print('MaoJogadorWidget');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: mao.asMap().entries.map((entry) {
        print(entry);
        final index = entry.key;
        final carta = entry.value;
        return CartaWidget(carta: carta, onTap: () {

            // Chama a função de callback com o índice da carta selecionada
            onCartaSelecionada(index+1);
            //print('Índice da carta selecionada: ${index+1}');
         
          //child: CartaWidget(carta: carta, onTap: () {
            // Não é necessário fazer nada aqui, pois o GestureDetector já cuidará do evento onTap

        });
      }).toList(),
    );
  }
}