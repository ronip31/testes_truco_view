import 'package:flutter/material.dart';
import '../models/carta.dart';

class CartaWidget extends StatelessWidget {
  final Carta carta;
  final VoidCallback onTap;

  CartaWidget({required this.carta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Carta ${carta.valor} ${carta.naipe} clicada');
        onTap(); // Chama a função onTap passada como parâmetro
      },
      child: Container(
        margin: EdgeInsets.all(4.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              carta.valor,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 4.0),
            Text(
              carta.naipe,
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
