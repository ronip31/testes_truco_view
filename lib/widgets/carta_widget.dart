import 'package:flutter/material.dart';
import '../models/carta.dart';

class CartaWidget extends StatelessWidget {
  final Carta carta; // A carta que será exibida pelo widget
  final VoidCallback onTap; // Ação a ser executada quando a carta for clicada
  final bool disabled; // Indica se a carta está desabilitada para interações

  const CartaWidget({
    super.key,
    required this.carta,
    required this.onTap,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap, // Desabilita a interação se `disabled` for true
      child: Container(
        width: 85.0,
        height: 135.0,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey : Colors.white, // Muda a cor de fundo se `disabled` for true
          border: Border.all(color: Colors.black), // Adiciona uma borda preta
          borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
        ),
        child: carta.img.isNotEmpty
            ? Image.asset(carta.img, fit: BoxFit.cover) // Exibe a imagem da carta se disponível
            : Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(carta.valor, style: const TextStyle(fontSize: 20.0)), // Exibe o valor da carta
                    Text(carta.naipe, style: const TextStyle(fontSize: 16.0)), // Exibe o naipe da carta
                  ],
                ),
              ),
      ),
    );
  }
}
