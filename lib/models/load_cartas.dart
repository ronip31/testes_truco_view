// import 'carta.dart';


// // List<Carta> loadCartas() {
// //   List<Carta> cartas = [];
// //   final suits = ['Copas', 'Espadas', 'Ouros', 'Paus'];
// //   final values = ['2', '3', '4', '5', '6', '7', 'Q', 'J', 'K', 'A'];

// //   for (String suit in suits) {
// //     for (String value in values) {
// //       final imagePath = 'assets/imgs/$value.$suit.png';
// //       //print('Criando carta: $value de $suit com caminho $imagePath');
// //       cartas.add(Carta(
// //         valor: value,
// //         naipe: suit,
// //         imagePath: imagePath,
// //       ));
// //     }
// //   }
// //   return cartas;
// // }


// //ideia para carregas apenas as cartas que estão na mãos dos jogadores.
// List<Carta> loadCartasNecessarias(List<List<Carta>> todasMaosJogadores) {
//   List<Carta> cartas = [];
//   final loadedCards = Set<String>();

//   for (var mao in todasMaosJogadores) {
//     for (var carta in mao) {
//       final key = '${carta.valor},${carta.naipe}';
//       if (!loadedCards.contains(key)) {
//         final imagePath = 'assets/imgs/${carta.valor}.${carta.naipe}.png';
//         cartas.add(Carta(
//           valor: carta.valor,
//           naipe: carta.naipe,
//          // imagePath: imagePath,
//         ));
//         loadedCards.add(key);
//       }
//     }
//   }
//   return cartas;
// }
