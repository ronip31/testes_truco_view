import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../models/jogador.dart';
import 'pedir_truco.dart';

class TrucoManager {
  Jogador? ultimoJogadorQuePediu; // Armazena o último jogador que pediu truco
  int pontosTrucoAtual = 1; // Pontuação atual da rodada (inicialmente 1 ponto)
  Truco truco = Truco();

  // Verifica se o jogador pode pedir truco
  bool podePedirTruco(Jogador jogador) {
    return jogador != ultimoJogadorQuePediu;
  }

  // Limpa o estado do truco
  void limpamap() {
    ultimoJogadorQuePediu = null;
    pontosTrucoAtual = 1; // Reseta a pontuação para 1 no início da nova rodada
  }

  // Obtém o próximo valor do truco baseado na pontuação atual
  int getNextTrucoValue() {
    switch (pontosTrucoAtual) {
      case 1:
        return 3;
      case 3:
        return 6;
      case 6:
        return 9;
      case 9:
        return 12;
      default:
        return 3;
    }
  }

  // Lida com o pressionamento do botão de truco
  Future<void> onTrucoButtonPressed(BuildContext context, Jogador jogadorQuePediuTruco, List<Jogador> jogadores, int jogadorAtualIndex) async {
    if (!podePedirTruco(jogadorQuePediuTruco)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você não pode pedir truco agora!')),
      );
      return;
    }

    // Determina os pontos que o truco será pedido
    int pontosTrucoSolicitado = getNextTrucoValue();
    Jogador jogadorQueRespondeTruco = jogadores[(jogadorAtualIndex + 1) % jogadores.length];

    // Solicita truco
    Tuple4<Jogador, Jogador?, int, int> resultado;
    if (pontosTrucoSolicitado == 3) {
      resultado = await truco.pedirTruco(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
    } else if (pontosTrucoSolicitado == 6) {
      resultado = await truco.pedir6(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
    } else if (pontosTrucoSolicitado == 9) {
      resultado = await truco.pedir9(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
    } else {
      resultado = await truco.pedir12(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
    }

    // Atualiza a pontuação atual do truco
    pontosTrucoAtual = resultado.item4;

    // Atualiza o último jogador que pediu truco
    ultimoJogadorQuePediu = jogadorQuePediuTruco;
  }
}
