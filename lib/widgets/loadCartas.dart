import '../models/carta.dart';

List<Carta> loadCartas() {
  List<Carta> cartas = [];
  final suits = ['Copas', 'Espadas', 'Ouros', 'Paus'];
  final values = ['2', '3', '4', '5', '6', '7', 'Q', 'J', 'K', 'A'];

  for (String suit in suits) {
    for (String value in values) {
      final imagePath = 'assets/imgs/$value.$suit.png';
      print('Criando carta: $value de $suit com caminho $imagePath');
      cartas.add(Carta(
        valor: value,
        naipe: suit,
        imagePath: imagePath,
      ));
    }
  }
  return cartas;
}
