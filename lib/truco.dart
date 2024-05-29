import 'package:flutter/material.dart';
import 'models/jogador.dart';
import 'pedir_truco.dart';


class TrucoGame extends StatefulWidget {
  const TrucoGame({super.key});

  @override
  TrucoGameState createState() => TrucoGameState();
}

class TrucoGameState extends State<TrucoGame> {
  int jogadorAtualIndex = 0;
  List<Jogador> jogadores = [Jogador("Jogador 1",1), Jogador("Jogador 2",2)];
  Truco truco = Truco();

  void _onTrucoButtonPressed(BuildContext context) async {
    Jogador jogadorQuePediuTruco = jogadores[jogadorAtualIndex];
    Jogador jogadorQueRespondeTruco = jogadores[(jogadorAtualIndex + 1) % jogadores.length];
    print('jogadorQuePediuTruco: $jogadorQuePediuTruco');
    await truco.pedirTruco(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truco Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Jogador atual: ${jogadores[jogadorAtualIndex].nome}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onTrucoButtonPressed(context),
              child: const Text('Pedir Truco'),
            ),
          ],
        ),
      ),
    );
  }
}