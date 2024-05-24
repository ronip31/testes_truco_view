import 'package:flutter/material.dart';
import 'models/carta.dart';
import 'widgets/JogoTrucoLayout.dart';
import 'widgets/loadCartas.dart';
import 'widgets/JogoTrucoScreen.dart';


void main() {
  List<Carta> cartas = loadCartas();
  runApp(MyApp(cartas: cartas));
}

class MyApp extends StatelessWidget {
  final List<Carta> cartas;

  MyApp({required this.cartas});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo de Truco',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: JogoTrucoScreen(cartas: cartas),
    );
  }
}
