import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'models/jogador.dart';

class Truco {
  static const int PONTOS_INICIAL = 3;
  static const int PONTOS_6 = 6;
  static const int PONTOS_9 = 9;
  static const int PONTOS_12 = 12;
  
  bool trucoFoiAceito = false;
  Jogador? jogadorQuePediuTruco;
  Jogador? jogadorQueAceitouTruco;
  int pontosTruco = Truco.PONTOS_INICIAL;
  int jogadorPediuTruco = 0;

  Future<Tuple4<Jogador, Jogador?, int, int>> pedirTruco(BuildContext context, Jogador jogadorQuePediuTruco, Jogador jogadorQueRespondeTruco, List<Jogador> jogadores) async {
    this.jogadorQuePediuTruco = jogadorQuePediuTruco;

    String? resposta = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('O jogador ${jogadorQuePediuTruco.nome} pediu truco!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Opções para o Grupo ${jogadorQueRespondeTruco.grupo} adversário:'),
              ListTile(
                title: Text('Aceitar (3 pontos)'),
                onTap: () => Navigator.of(context).pop('1'),
              ),
              ListTile(
                title: Text('Pedir 6 (6 pontos)'),
                onTap: () => Navigator.of(context).pop('2'),
              ),
              ListTile(
                title: Text('Recusar'),
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
        pontosTruco = PONTOS_INICIAL;
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
          title: Text('O jogador ${jogadorQueRespondeTruco.nome} pediu 6!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Opções para o Grupo ${jogadorQuePediuTruco.grupo} adversário:'),
              ListTile(
                title: Text('Aceitar (6 pontos)'),
                onTap: () => Navigator.of(context).pop('1'),
              ),
              ListTile(
                title: Text('Pedir 9 (9 pontos)'),
                onTap: () => Navigator.of(context).pop('2'),
              ),
              ListTile(
                title: Text('Recusar'),
                onTap: () => Navigator.of(context).pop('3'),
              ),
            ],
          ),
        );
      },
    );

    switch (resposta6) {
      case '1':
        trucoFoiAceito = true;
        jogadorQueAceitouTruco = jogadorQuePediuTruco;
        pontosTruco = PONTOS_6;
        break;
      case '2':
        return await pedir9(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
      case '3':
        pontosTruco = PONTOS_INICIAL;
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
          title: Text('O jogador ${jogadorQuePediuTruco.nome} pediu 9!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Opções para o Grupo ${jogadorQueRespondeTruco.grupo} adversário:'),
              ListTile(
                title: Text('Aceitar (9 pontos)'),
                onTap: () => Navigator.of(context).pop('1'),
              ),
              ListTile(
                title: Text('Pedir 12 (12 pontos)'),
                onTap: () => Navigator.of(context).pop('2'),
              ),
              ListTile(
                title: Text('Recusar'),
                onTap: () => Navigator.of(context).pop('3'),
              ),
            ],
          ),
        );
      },
    );

    switch (resposta9) {
      case '1':
        trucoFoiAceito = true;
        jogadorQueAceitouTruco = jogadorQueRespondeTruco;
        pontosTruco = PONTOS_9;
        break;
      case '2':
        return await pedir12(context, jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
      case '3':
        pontosTruco = PONTOS_6;
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
          title: Text('O jogador ${jogadorQueRespondeTruco.nome} pediu 12!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Opções para o Grupo ${jogadorQuePediuTruco.grupo} adversário:'),
              ListTile(
                title: Text('Aceitar (12 pontos)'),
                onTap: () => Navigator.of(context).pop('1'),
              ),
              ListTile(
                title: Text('Recusar'),
                onTap: () => Navigator.of(context).pop('2'),
              ),
            ],
          ),
        );
      },
    );

    switch (resposta12) {
      case '1':
        pontosTruco = PONTOS_12;
        trucoFoiAceito = true;
        jogadorQueAceitouTruco = jogadorQueRespondeTruco;
        break;
      case '2':
        pontosTruco = PONTOS_9;
        jogadorQuePediuTruco.adicionarPontuacaoTotalTruco(pontosTruco);
        break;
      default:
        print('Opção inválida.');
    }

    return Tuple4<Jogador, Jogador?, int, int>(jogadorQuePediuTruco, jogadorQueRespondeTruco, 0, pontosTruco);
  }
}
