import 'package:tuple/tuple.dart';
import 'models/jogador.dart';
import 'main.dart';
import 'dart:io';

class Truco {
  static const int PONTOS_INICIAL = 3;
  static const int PONTOS_6 = 6;
  static const int PONTOS_9 = 9;
  static const int PONTOS_12 = 12;
  
  bool trucoFoiAceito = false;
  Jogador? jogadorQuePediuTruco;
  Jogador? jogadorQueAceitouTruco;
  int pontosTruco = Truco.PONTOS_INICIAL;
  int jogadorPediutruco = 0;

  Tuple4<Jogador, Jogador?, int, int>  pedirTruco(Jogador jogadorQuePediuTruco, Jogador jogadorQueRespondeTruco, List<Jogador> jogadores) {
  print('O jogador ${jogadorQuePediuTruco.nome} pediu truco!');

  // Mostra as opções para a equipe adversária
  print('\r\nOpções para o Grupo ${jogadorQueRespondeTruco.grupo} adversário:');
  print('1. Aceitar (3 pontos)');
  print('2. Pedir 6 (6 pontos)');
  print('3. Recusar');

  // Lê a resposta da equipe adversária
  stdout.write('Escolha a opção (1/2/3): ');
  String? resposta = stdin.readLineSync();

  switch (resposta) {
    case '1':
      trucoFoiAceito = true;
      jogadorQueAceitouTruco = jogadorQueRespondeTruco;
      jogadorPediutruco = jogadores.indexOf(jogadorQuePediuTruco);
      print('O truco foi aceito! Pelo jogador ${jogadorQueRespondeTruco.nome} do grupo ${jogadorQueRespondeTruco.grupo} aceitou o truco! A mão passa a valer $pontosTruco pontos.');
      break;
    case '2':
      print('O jogador ${jogadorQueRespondeTruco.nome} pediu 6!');

      // Mostra as opções para a equipe adversária
      print('\r\nOpções para o Grupo ${jogadorQuePediuTruco.grupo} adversário:');
      print('1. Aceitar (6 pontos)');
      print('2. Pedir 9 (9 pontos)');
      print('3. Recusar');

      // Lê a resposta da equipe adversária
      stdout.write('Escolha a opção (1/2/3): ');
      String? resposta6 = stdin.readLineSync();

      switch (resposta6) {
        case '1':
          trucoFoiAceito = true;
          jogadorQueAceitouTruco = jogadorQuePediuTruco;
          pontosTruco = Truco.PONTOS_6;
          print('O truco foi aceito! Pelo jogador ${jogadorQuePediuTruco.nome} do grupo ${jogadorQuePediuTruco.grupo} aceitou o aumento de truco para $pontosTruco pontos.');
          break;
        case '2':
          print('O jogador ${jogadorQuePediuTruco.nome} pediu 9!');

          // Mostra as opções para a equipe adversária
          print('\r\nOpções para o Grupo ${jogadorQueRespondeTruco.grupo} adversário:');
          print('1. Aceitar (9 pontos)');
          print('2. Pedir 12 (12 pontos)');
          print('3. Recusar');

          // Lê a resposta da equipe adversária
          stdout.write('Escolha a opção (1/2/3): ');
          String? resposta9 = stdin.readLineSync();

          switch (resposta9) {
            case '1':
              trucoFoiAceito = true;
              jogadorQueAceitouTruco = jogadorQueRespondeTruco;
              pontosTruco = Truco.PONTOS_9;
              print('O truco foi aceito! Pelo jogador ${jogadorQueRespondeTruco.nome} do grupo ${jogadorQueRespondeTruco.grupo} aceitou o aumento de truco para $pontosTruco pontos.');
              break;
            case '2':
              responderAo12(jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
              break;
            case '3':
              print('O jogador ${jogadorQuePediuTruco.nome} recusou o truco! A equipe que pediu truco recebe um ponto e a mão.');
              pontosTruco = Truco.PONTOS_6;
              jogadorQuePediuTruco.adicionarPontuacaoTotalTruco(pontosTruco);
              break;
            default:
              print('Opção inválida.');
          }
          break;
        case '3':
          print('O jogador ${jogadorQuePediuTruco.nome} recusou o truco! A equipe que pediu truco recebe um ponto e a mão.');
          pontosTruco = Truco.PONTOS_INICIAL;
          jogadorQuePediuTruco.adicionarPontuacaoTotalTruco(pontosTruco);
          break;
        default:
          print('Opção inválida.');
      }
      break;
    case '3':
      print('O jogador ${jogadorQuePediuTruco.nome} recusou o truco! A equipe que pediu truco recebe um ponto e a mão.');
      pontosTruco = 1;
      jogadorQuePediuTruco.adicionarPontuacaoTotalTruco(pontosTruco);
      break;
    default:
      print('Opção inválida.');
  }
    print('jogadorQuePediuTruco: ${jogadorQuePediuTruco.nome}, jogadorQueAceitouTruco :${jogadorQueRespondeTruco.grupo} e pontos ${pontosTruco}');
    
  int trucoTrue = -1;
  
   return Tuple4<Jogador, Jogador?, int, int>(jogadorQuePediuTruco, jogadorQueRespondeTruco, 0, pontosTruco);
}


  void responderAo12(Jogador jogadorQuePediuTruco, Jogador jogadorQueRespondeTruco, List<Jogador> jogadores) {
    print('${jogadorQuePediuTruco.nome} pediu 12!');

    // Mostra as opções para a equipe adversária
    print('\r\nOpções para o Grupo ${jogadorQueRespondeTruco.grupo} adversário:');
    print('1. Aceitar (12 pontos)');
    print('2. Recusar');

    // Lê a resposta da equipe adversária
    stdout.write('Escolha a opção (1/2): ');
    String? resposta12 = stdin.readLineSync();

    switch (resposta12) {
      case '1':
        pontosTruco = Truco.PONTOS_12;
        print('O jogador ${jogadorQueRespondeTruco.nome} aceitou o 12! A mão passa a valer $pontosTruco pontos.');
        break;
      case '2':
        print('O jogador ${jogadorQueRespondeTruco.nome} recusou o 12! A equipe que pediu truco recebe um ponto e a mão.');
        pontosTruco = Truco.PONTOS_9;
        jogadorQuePediuTruco.adicionarPontuacaoTotalTruco(pontosTruco);
        break;
      default:
        print('Opção inválida.');
    }
  }
  
}

