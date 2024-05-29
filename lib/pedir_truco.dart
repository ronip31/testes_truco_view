import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'models/jogador.dart';

class Truco {
  static const int pontosInicial = 3;
  static const int pontos_6 = 6;
  static const int pontos_9 = 9;
  static const int pontos_12 = 12;
  
  bool trucoFoiAceito = false;
  Jogador? jogadorQuePediuTruco;
  Jogador? jogadorQueAceitouTruco;
  int pontosTruco = Truco.pontosInicial;
  int jogadorPediuTruco = 0;

  Future<Tuple4<Jogador, Jogador?, int, int>> pedirTruco(BuildContext context, Jogador jogadorQuePediuTruco, Jogador jogadorQueRespondeTruco, List<Jogador> jogadores) async {
    this.jogadorQuePediuTruco = jogadorQuePediuTruco;
    print('jogadorQuePediuTruco: $jogadorQuePediuTruco');
    String? resposta = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('O ${jogadorQuePediuTruco.nome} pediu truco!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Opções para o ${jogadorQueRespondeTruco.nome} adversário:'),
              ListTile(
                title: const Text('Aceitar (3 pontos)'),
                onTap: () => Navigator.of(context).pop('1'),
              ),
              ListTile(
                title: const Text('Pedir 6 (6 pontos)'),
                onTap: () => Navigator.of(context).pop('2'),
              ),
              ListTile(
                title: const Text('Recusar'),
                onTap: () => Navigator.of(context).pop('3'),
              ),
            ],
          ),
        );
      },
    );

    switch (resposta) {
      case '1':
        trucoFoiAceito = true;
        jogadorQueAceitouTruco = jogadorQueRespondeTruco;
        jogadorPediuTruco = jogadores.indexOf(jogadorQuePediuTruco);
        pontosTruco = pontosInicial;
        break;
      case '2':
        return await pedir6(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
      case '3':
        pontosTruco = 1;
        jogadorQuePediuTruco.adicionarPontuacaoTotalTruco(pontosTruco);
        break;
      default:
        print('Opção inválida.');
    }

    return Tuple4<Jogador, Jogador?, int, int>(jogadorQuePediuTruco, jogadorQueRespondeTruco, 0, pontosTruco);
  }

  Future<Tuple4<Jogador, Jogador?, int, int>> pedir6(BuildContext context, Jogador jogadorQuePediuTruco, Jogador jogadorQueRespondeTruco, List<Jogador> jogadores) async {
    String? resposta6 = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('O ${jogadorQueRespondeTruco.nome} pediu 6!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Opções para o ${jogadorQuePediuTruco.nome} adversário:'),
              ListTile(
                title: const Text('Aceitar (6 pontos)'),
                onTap: () => Navigator.of(context).pop('1'),
              ),
              ListTile(
                title: const Text('Pedir 9 (9 pontos)'),
                onTap: () => Navigator.of(context).pop('2'),
              ),
              ListTile(
                title: const Text('Recusar'),
                onTap: () => Navigator.of(context).pop('3'),
              ),
            ],
          ),
        );
      },
    );

    switch (resposta6) {
        
      case '1':
        print('resposta6: $resposta6');
        trucoFoiAceito = true;
        jogadorQueAceitouTruco = jogadorQuePediuTruco;
        pontosTruco = pontos_6;
        break;
      case '2':
        return await pedir9(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
      case '3':
        pontosTruco = pontosInicial;
        jogadorQuePediuTruco.adicionarPontuacaoTotalTruco(pontosTruco);
        break;
      default:
        print('Opção inválida.');
    }

    return Tuple4<Jogador, Jogador?, int, int>(jogadorQuePediuTruco, jogadorQueRespondeTruco, 0, pontosTruco);
  }

  Future<Tuple4<Jogador, Jogador?, int, int>> pedir9(BuildContext context, Jogador jogadorQuePediuTruco, Jogador jogadorQueRespondeTruco, List<Jogador> jogadores) async {
    String? resposta9 = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('O ${jogadorQuePediuTruco.nome} pediu 9!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Opções para o ${jogadorQueRespondeTruco.nome} adversário:'),
              ListTile(
                title: const Text('Aceitar (9 pontos)'),
                onTap: () => Navigator.of(context).pop('1'),
              ),
              ListTile(
                title: const Text('Pedir 12 (12 pontos)'),
                onTap: () => Navigator.of(context).pop('2'),
              ),
              ListTile(
                title: const Text('Recusar'),
                onTap: () => Navigator.of(context).pop('3'),
              ),
            ],
          ),
        );
      },
    );

    switch (resposta9) {
      case '1':
        print('resposta9: $resposta9');
        trucoFoiAceito = true;
        jogadorQueAceitouTruco = jogadorQueRespondeTruco;
        pontosTruco = pontos_9;
        break;
      case '2':
        return await pedir12(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
      case '3':
        pontosTruco = pontos_6;
        jogadorQuePediuTruco.adicionarPontuacaoTotalTruco(pontosTruco);
        break;
      default:
        print('Opção inválida.');
    }

    return Tuple4<Jogador, Jogador?, int, int>(jogadorQuePediuTruco, jogadorQueRespondeTruco, 0, pontosTruco);
  }

  Future<Tuple4<Jogador, Jogador?, int, int>> pedir12(BuildContext context, Jogador jogadorQuePediuTruco, Jogador jogadorQueRespondeTruco, List<Jogador> jogadores) async {
    String? resposta12 = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('O ${jogadorQueRespondeTruco.nome} pediu 12!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Opções para o ${jogadorQuePediuTruco.nome} adversário:'),
              ListTile(
                title: const Text('Aceitar (12 pontos)'),
                onTap: () => Navigator.of(context).pop('1'),
              ),
              ListTile(
                title: const Text('Recusar'),
                onTap: () => Navigator.of(context).pop('2'),
              ),
            ],
          ),
        );
      },
    );

    switch (resposta12) {
      case '1':
      print('resposta12: $resposta12');
        pontosTruco = pontos_12;
        trucoFoiAceito = true;
        jogadorQueAceitouTruco = jogadorQueRespondeTruco;
        break;
      case '2':
        pontosTruco = pontos_9;
        jogadorQuePediuTruco.adicionarPontuacaoTotalTruco(pontosTruco);
        break;
      default:
        print('Opção inválida.');
    }

    return Tuple4<Jogador, Jogador?, int, int>(jogadorQuePediuTruco, jogadorQueRespondeTruco, 0, pontosTruco);
  }
}