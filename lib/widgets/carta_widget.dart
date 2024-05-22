import 'package:flutter/material.dart';
import '../models/carta.dart';

class CartaWidget extends StatelessWidget {
  final Carta carta;
  final VoidCallback onTap;
  final bool disabled;

  CartaWidget({
    required this.carta,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0, // Cartas jogadas
        child: Container(
          width: 85.0,  // Ajuste a largura da carta
          height: 135.0,
          margin: const EdgeInsets.all(10.0), 
          decoration: BoxDecoration(
            // color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              spreadRadius: 3,
              blurRadius: 25,
              ),
            ],
           ),
           // Ajuste a altura da carta
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(carta.valor, style: TextStyle(fontSize: 20.0)), // Ajuste o tamanho do texto se necessário
                Text(carta.naipe, style: TextStyle(fontSize: 16.0)), // Ajuste o tamanho do texto se necessário
              ],
            ),
          ),
        ),
      ),
    );
  }
}
