import '../models/carta.dart';
import 'dart:io';



//Interage com o jogador para obter a quantidade de jogadores
int obterNumeroJogadores() {
  int? numeroJogadores;
  bool numeroValido = false;
  
  while (!numeroValido) {
    stdout.write('Quantos jogadores deseja (2 ou 4)? ');
    String? entrada = stdin.readLineSync();

    // Verifica se a entrada não é nula
    if (entrada != null) {
      numeroJogadores = int.tryParse(entrada);
    }

    // Verifica se o número de jogadores é válido
    if (numeroJogadores != 2 && numeroJogadores != 4) {
      print('Número de jogadores inválido.');
    } else {
      numeroValido = true;
    }
  }
  return numeroJogadores!;
}

