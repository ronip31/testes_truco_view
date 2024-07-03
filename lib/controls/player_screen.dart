import 'package:flutter/material.dart';
import 'jogo_truco_player_screen.dart';
import '../interface_user/user_interface.dart';
import '../controls/score_manager.dart';
import 'resultado_rodada.dart';


class PlayerScreen extends JogoTrucoPlayerScreen {
  const PlayerScreen({Key? key, required String roomId, required String playerName})
      : super(key: key, roomId: roomId, playerName: playerName);

  @override
  JogoTrucoPlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends JogoTrucoPlayerScreenState<PlayerScreen> {
  Pontuacao pontuacao = Pontuacao();
  List<ResultadoRodada> resultadosRodadas = [];
  String resultadoRodada = '';

  @override
  Widget build(BuildContext context) {
    if (!gameReady) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Aguardando o início do jogo...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return JogoTrucoLayout(
      jogadorAtual: jogadorAtual,
      gameLogic: gameLogic,
      firebaseService: firebaseService,
      jogadores: jogadores,
      resultadoRodada: resultadoRodada,
      cartasJogadasNaMesa: gameLogic.cartasJogadasNaMesa,
      manilha: manilha,
      pontuacao: pontuacao,
      onCartaSelecionada: (index) {
        if (index >= 0 && index < jogadorAtual.mao.length) {
          var cartaSelecionada = jogadorAtual.mao[index];
          gameLogic.jogarCarta(cartaSelecionada, context);
        }
      },
      rodadacontinua: true,
      onEsconderPressed: () {},
    );
  }
}
