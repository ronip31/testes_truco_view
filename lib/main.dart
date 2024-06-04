import 'package:flutter/material.dart';
import 'models/carta.dart';
import 'models/load_cartas.dart';
import 'controls/game_state.dart';

void main() {
  List<Carta> cartas = loadCartas();
  runApp(MyApp(cartas: cartas));
}

class MyApp extends StatelessWidget {
  final List<Carta> cartas;

  const MyApp({super.key, required this.cartas});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRUCO ROYALE',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: JogoTrucoScreen(cartas: cartas),
    );
  }
}
