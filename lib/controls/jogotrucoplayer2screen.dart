import 'package:flutter/material.dart';
import 'jogo_truco_player_screen.dart';
import '../interface_user/user_interface.dart';
import '../controls/score_manager.dart';


class JogoTrucoPlayer2Screen extends JogoTrucoPlayerScreen {
  const JogoTrucoPlayer2Screen({Key? key, required String roomId, required String playerName})
      : super(key: key, roomId: roomId, playerName: playerName);

  @override
  JogoTrucoPlayerScreenState createState() => _JogoTrucoPlayer2ScreenState();
}

class _JogoTrucoPlayer2ScreenState extends JogoTrucoPlayerScreenState<JogoTrucoPlayer2Screen> {
  Pontuacao pontuacao = Pontuacao();

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
      resultadoRodada: '',
      cartasJogadasNaMesa: gameLogic.cartasJogadasNaMesa,
      manilha: manilha,
      pontuacao: Pontuacao(),
      onCartaSelecionada: (index) {
        if (index >= 0 && index < jogadorAtual.mao.length) {
          var cartaSelecionada = jogadorAtual.mao[index];
          jogarCarta(cartaSelecionada);
        }
      },
      rodadacontinua: true,
      onEsconderPressed: () {},
    );
  }
}

