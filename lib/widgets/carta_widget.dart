import 'package:flutter/material.dart';
import '../models/carta.dart';

class CartaWidget extends StatelessWidget {
  final Carta carta;
  final VoidCallback onTap;
  final bool disabled;

  const CartaWidget({super.key, 
    required this.carta,
    required this.onTap,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 85.0,
        height: 135.0,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey : Colors.white,
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
  }
}
