import 'package:flutter/material.dart';
import 'jogo_truco_player_screen.dart';
import '../interface_user/user_interface.dart';
import '../controls/score_manager.dart';
import 'resultado_rodada.dart';

// Classe PlayerScreen que estende JogoTrucoPlayerScreen
class PlayerScreen extends JogoTrucoPlayerScreen {
  const PlayerScreen({Key? key, required String roomId, required String playerName})
      : super(key: key, roomId: roomId, playerName: playerName);

  @override
  JogoTrucoPlayerScreenState createState() => _PlayerScreenState();
}

// Classe de estado para PlayerScreen
class _PlayerScreenState extends JogoTrucoPlayerScreenState<PlayerScreen> {
  Pontuacao pontuacao = Pontuacao(); // Gerencia a pontuação do jogo
  List<ResultadoRodada> resultadosRodadas = []; // Armazena os resultados das rodadas
  String resultadoRodada = ''; // Armazena o resultado da rodada atual

  @override
  Widget build(BuildContext context) {
    // Verifica se o jogo está pronto
    if (!gameReady) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Aguardando o início do jogo...'), // Título da AppBar enquanto espera
        ),
        body: const Center(
          child: CircularProgressIndicator(), // Indicador de progresso
        ),
      );
    }

    // Retorna o layout do jogo quando está pronto
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
          var cartaSelecionada = jogadorAtual.mao[index]; // Seleciona a carta da mão do jogador
          gameLogic.jogarCarta(cartaSelecionada, context); // Joga a carta
        }
      },
      rodadacontinua: true,
      onEsconderPressed: () {}, // Placeholder para o botão de esconder
    );
  }
}
