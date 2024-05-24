import 'package:flutter/material.dart';

class PontuacaoWidget extends StatelessWidget {
  final int nos;
  final int eles;

  PontuacaoWidget({required this.nos, required this.eles});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Cor de fundo com opacidade
        borderRadius: BorderRadius.circular(8.0), // Borda arredondada
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2), // Sombra para baixo
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text('Nós', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              Text(nos.toString(), style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            children: [
              Text('Eles', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              Text(eles.toString(), style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}