import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'models/jogador.dart';
import 'truco.dart';
import 'widgets/trucobutton.dart';
import 'pedirTruco.dart';


class TrucoGamePage extends StatefulWidget {
  @override
  _TrucoGamePageState createState() => _TrucoGamePageState();
}

class _TrucoGamePageState extends State<TrucoGamePage> {
  List<Jogador> jogadores = [Jogador('Jogador 1', 1), Jogador('Jogador 2',2)];  // Exemplo de jogadores
  int jogadorAtualIndex = 0;  // Índice do jogador atual
  Truco truco = Truco();
  
  void _pedirTruco() async {
    Jogador jogadorQuePediuTruco = jogadores[jogadorAtualIndex];
    Jogador jogadorQueRespondeTruco = jogadores[(jogadorAtualIndex + 1) % jogadores.length];

    var resultado = await truco.pedirTruco(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);

    // Atualizar o estado do jogo com base no resultado
    setState(() {
      // Atualize o estado do jogo aqui se necessário
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo de Truco'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Jogador Atual: ${jogadores[jogadorAtualIndex].nome}'),
            // Outros widgets do jogo
            TrucoButton(onPressed: _pedirTruco),
          ],
        ),
      ),
    );
  }
}
