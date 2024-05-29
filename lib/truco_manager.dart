import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'models/jogador.dart';
import '../pedir_truco.dart';

class TrucoManager {
  Map<Jogador, Tuple2<int, int>> trucoMap = {}; // Jogador, (pontos, ordem)
  int ordemAtual = 0;
  Truco truco = Truco();

  bool podePedirTruco(Jogador jogador, int pontosAtual) {
    if (trucoMap.isEmpty) {
      return true;
    }

    if (trucoMap.containsKey(jogador)) {
      // Se o jogador já pediu truco, ele não pode pedir novamente até que a rodada termine
      return false;
    }

    // Verifica se o jogador pode pedir truco com base na ordem e nos pontos
    for (var entry in trucoMap.entries) {
      int pontos = entry.value.item1;
      int ordem = entry.value.item2;

      // Verifica se a ordem atual é do jogador que pediu truco ou se a sequência está correta
      if (ordem == ordemAtual && pontosAtual == getNextTrucoValue(pontos)) {
        return true;
      }
    }

    return false;
  }

  void limpamap(){
    trucoMap.clear();
  }

  int getNextTrucoValue(int currentPoints) {
    switch (currentPoints) {
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

  void atualizarOrdem() {
    ordemAtual = (ordemAtual + 1) % trucoMap.length;
  }

  Future<void> onTrucoButtonPressed(BuildContext context, Jogador jogadorQuePediuTruco, List<Jogador> jogadores, int jogadorAtualIndex) async {
    int pontosTrucoAtual = trucoMap.isEmpty ? 3 : truco.trucoFoiAceito ? truco.pontosTruco : 3;
    Jogador jogadorQueRespondeTruco = jogadores[(jogadorAtualIndex + 1) % jogadores.length];
    
    if (!podePedirTruco(jogadorQuePediuTruco, pontosTrucoAtual)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você não pode pedir truco agora!')),
      );
      return;
    }

    await truco.pedirTruco(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
    
    // Atualiza o mapa com as informações do truco
    trucoMap[jogadorQuePediuTruco] = Tuple2(truco.pontosTruco, ordemAtual);
    trucoMap[jogadorQueRespondeTruco] = Tuple2(truco.pontosTruco, (ordemAtual + 1) % 2);
    atualizarOrdem();
  }
}
