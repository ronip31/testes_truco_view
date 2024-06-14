import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../models/jogador.dart';
import '../interface_user/trucodialog.dart';

class Truco {
  // Constantes para os pontos de cada nível de truco
  static const int pontosInicial = 3;
  static const int pontos_6 = 6;
  static const int pontos_9 = 9;
  static const int pontos_12 = 12;

  // Variáveis de estado para o truco
  bool trucoFoiAceito = false; // Indica se o truco foi aceito
  Jogador? jogadorQuePediuTruco; // Jogador que pediu o truco
  Jogador? jogadorQueAceitouTruco; // Jogador que aceitou o truco
  int pontosTruco = 0; // Pontos atuais do truco

  // Método para pedir truco (3 pontos)
  Future<Tuple4<Jogador, Jogador?, int, int>> pedirTruco(BuildContext context, Jogador jogadorQuePediuTruco, Jogador jogadorQueRespondeTruco, List<Jogador> jogadores) async {
    this.jogadorQuePediuTruco = jogadorQuePediuTruco; // Define o jogador que pediu truco
    print('jogadorQuePediuTruco: ${jogadorQuePediuTruco.nome}');
    
    // Mostra o diálogo de truco
    String? resposta = await TrucoDialog.showTrucoDialog(
      context,
      'O ${jogadorQuePediuTruco.nome} pediu truco!',
      'Opções para o ${jogadorQueRespondeTruco.nome} adversário:',
      ['Aceitar (3 pontos)', 'Pedir 6 (6 pontos)', 'Recusar']
    );

    // Processa a resposta do diálogo
    switch (resposta) {
      case '0': // Aceitar truco
        trucoFoiAceito = true;
        pontosTruco = pontosInicial; // Define os pontos do truco para 3
        break;
      case '1': // Pedir 6
        return await pedir6(context, jogadorQueRespondeTruco, jogadorQuePediuTruco, jogadores);
      case '2': // Recusar
        pontosTruco = 1; // Define os pontos do truco para 1
        jogadorQuePediuTruco.pontuacao.adicionarPontuacaoTotalTruco(pontosTruco);
        break;
      default: // Opção inválida
        print('Opção inválida.');
    }

    // Retorna o resultado da operação
    return Tuple4<Jogador, Jogador?, int, int>(jogadorQuePediuTruco, jogadorQueRespondeTruco, 0, pontosTruco);
  }

  // Método para pedir 6 pontos
  Future<Tuple4<Jogador, Jogador?, int, int>> pedir6(BuildContext context, Jogador jogadorQuePediu6, Jogador jogadorQueResponde6, List<Jogador> jogadores) async {
    // Mostra o diálogo de truco para 6 pontos
    String? resposta6 = await TrucoDialog.showTrucoDialog(
      context,
      'O ${jogadorQuePediu6.nome} pediu 6!',
      'Opções para o ${jogadorQueResponde6.nome} adversário:',
      ['Aceitar (6 pontos)', 'Pedir 9 (9 pontos)', 'Recusar']
    );

    // Processa a resposta do diálogo
    switch (resposta6) {
      case '0': // Aceitar truco de 6 pontos
        print('resposta6: $resposta6');
        trucoFoiAceito = true;
        pontosTruco = pontos_6; // Define os pontos do truco para 6
        break;
      case '1': // Pedir 9 pontos
        return await pedir9(context, jogadorQueResponde6, jogadorQuePediu6, jogadores);
      case '2': // Recusar
        pontosTruco = pontosInicial; // Define os pontos do truco para 3
        jogadorQuePediu6.pontuacao.adicionarPontuacaoTotalTruco(pontosTruco);
        break;
      default: // Opção inválida
        print('Opção inválida.');
    }

    // Retorna o resultado da operação
    return Tuple4<Jogador, Jogador?, int, int>(jogadorQuePediu6, jogadorQueResponde6, 0, pontosTruco);
  }

  // Método para pedir 9 pontos
  Future<Tuple4<Jogador, Jogador?, int, int>> pedir9(BuildContext context, Jogador jogadorQuePediu9, Jogador jogadorQueResponde9, List<Jogador> jogadores) async {
    // Mostra o diálogo de truco para 9 pontos
    String? resposta9 = await TrucoDialog.showTrucoDialog(
      context,
      'O ${jogadorQuePediu9.nome} pediu 9!',
      'Opções para o ${jogadorQueResponde9.nome} adversário:',
      ['Aceitar (9 pontos)', 'Pedir 12 (12 pontos)', 'Recusar']
    );

    // Processa a resposta do diálogo
    switch (resposta9) {
      case '0': // Aceitar truco de 9 pontos
        print('resposta9: $resposta9');
        trucoFoiAceito = true;
        pontosTruco = pontos_9; // Define os pontos do truco para 9
        break;
      case '1': // Pedir 12 pontos
        return await pedir12(context, jogadorQueResponde9, jogadorQuePediu9, jogadores);
      case '2': // Recusar
        pontosTruco = pontos_6; // Define os pontos do truco para 6
        jogadorQuePediu9.pontuacao.adicionarPontuacaoTotalTruco(pontosTruco);
        break;
      default: // Opção inválida
        print('Opção inválida.');
    }

    // Retorna o resultado da operação
    return Tuple4<Jogador, Jogador?, int, int>(jogadorQuePediu9, jogadorQueResponde9, 0, pontosTruco);
  }

  // Método para pedir 12 pontos
  Future<Tuple4<Jogador, Jogador?, int, int>> pedir12(BuildContext context, Jogador jogadorQuePediu12, Jogador jogadorQueResponde12, List<Jogador> jogadores) async {
    // Mostra o diálogo de truco para 12 pontos
    String? resposta12 = await TrucoDialog.showTrucoDialog(
      context,
      'O ${jogadorQueResponde12.nome} pediu 12!',
      'Opções para o ${jogadorQuePediu12.nome} adversário:',
      ['Aceitar (12 pontos)', 'Recusar']
    );

    // Processa a resposta do diálogo
    switch (resposta12) {
      case '0': // Aceitar truco de 12 pontos
        print('resposta12: $resposta12');
        pontosTruco = pontos_12; // Define os pontos do truco para 12
        trucoFoiAceito = true;
        break;
      case '1': // Recusar
        pontosTruco = pontos_9; // Define os pontos do truco para 9
        jogadorQuePediu12.pontuacao.adicionarPontuacaoTotalTruco(pontosTruco);
        break;
      default: // Opção inválida
        print('Opção inválida.');
    }

    // Retorna o resultado da operação
    return Tuple4<Jogador, Jogador?, int, int>(jogadorQuePediu12, jogadorQueResponde12, 0, pontosTruco);
  }
}
