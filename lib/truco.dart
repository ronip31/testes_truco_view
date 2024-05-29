// import 'package:flutter/material.dart';
// import 'package:tuple/tuple.dart';
// import 'models/jogador.dart';
// import 'pedir_truco.dart';

// class JogoTrucoLayout extends StatefulWidget {
//   const JogoTrucoLayout({super.key});

//   @override
//   JogoTrucoLayoutState createState() => JogoTrucoLayoutState();
// }

// class JogoTrucoLayoutState extends State<JogoTrucoLayout> {
//   int jogadorAtualIndex = 0;
//   List<Jogador> jogadores = [Jogador("Jogador 1", 1), Jogador("Jogador 2", 2)];
//   Truco truco = Truco();

//   Map<Jogador, Tuple2<int, int>> trucoMap = {}; // Jogador, (pontos, ordem)
//   int ordemAtual = 0;

//   bool podePedirTruco(Jogador jogador) {
//     if (trucoMap.isEmpty || !trucoMap.containsKey(jogador)) {
//       return true;
//     }
//     int ordemJogador = trucoMap[jogador]!.item2;
//     return ordemJogador == ordemAtual;
//   }

//   void atualizarOrdem() {
//     ordemAtual = (ordemAtual + 1) % trucoMap.length;
//   }

//   void _onTrucoButtonPressed(BuildContext context) async {
//     Jogador jogadorQuePediuTruco = jogadores[jogadorAtualIndex];
//     Jogador jogadorQueRespondeTruco = jogadores[(jogadorAtualIndex + 1) % jogadores.length];
    
//     if (!podePedirTruco(jogadorQuePediuTruco)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Você não pode pedir truco agora!')),
//       );
//       return;
//     }

//     print('jogadorQuePediuTruco _onTrucoButtonPressed: ${jogadorQuePediuTruco.nome}');
//     print('jogadorQueRespondeTruco _onTrucoButtonPressed: ${jogadorQueRespondeTruco.nome}');
//     await truco.pedirTruco(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
    
//     // Atualiza o mapa com as informações do truco
//     trucoMap[jogadorQuePediuTruco] = Tuple2(truco.pontosTruco, ordemAtual);
//     trucoMap[jogadorQueRespondeTruco] = Tuple2(truco.pontosTruco, (ordemAtual + 1) % 2);
//     atualizarOrdem();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Jogo de Truco'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Jogador atual: ${jogadores[jogadorAtualIndex].nome}'),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () => _onTrucoButtonPressed(context),
//                   child: const Text('Pedir Truco'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }