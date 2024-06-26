import 'package:flutter/material.dart';
import 'jogo_truco_player_screen.dart';
import '../interface_user/user_interface.dart';
import '../controls/score_manager.dart';

class JogoTrucoPlayer1Screen extends JogoTrucoPlayerScreen {
  const JogoTrucoPlayer1Screen({Key? key, required String roomId, required String playerName})
      : super(key: key, roomId: roomId, playerName: playerName);

  @override
  JogoTrucoPlayerScreenState createState() => _JogoTrucoPlayer1ScreenState();
}

class _JogoTrucoPlayer1ScreenState extends JogoTrucoPlayerScreenState<JogoTrucoPlayer1Screen> {
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
      pontuacao: pontuacao,
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