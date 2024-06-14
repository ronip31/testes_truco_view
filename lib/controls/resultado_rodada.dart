import '../models/jogador.dart';

class ResultadoRodada {
  final int numeroRodada;
  final Jogador? jogadorVencedor;

  ResultadoRodada(this.numeroRodada, this.jogadorVencedor);
}

bool empatouRodada(ResultadoRodada resultado) {
  //print('passou em empatouRodada');
  return resultado.jogadorVencedor == null;
}

Jogador? vencedor(ResultadoRodada resultado) {
  //print('passou em  vencedor');
  return resultado.jogadorVencedor;
}

Jogador? determinarVencedor(List<ResultadoRodada> resultadosRodadas) {
  //print("método determinarVencedor");
  // Verifica se há pelo menos três rodadas
  if (resultadosRodadas.length >= 3) {
    // Verifica se as duas primeiras rodadas terminaram em empate
    if (empatouRodada(resultadosRodadas[0]) && empatouRodada(resultadosRodadas[1])) {
      // verifica o vencedor da terceira
        return vencedor(resultadosRodadas[2]);
    }
    // Verifica se o jogador venceu a primeira e a terceira rodadas
    else if (vencedor(resultadosRodadas[0]) == vencedor(resultadosRodadas[2])) {
      return vencedor(resultadosRodadas[0]);
    }
    else if (vencedor(resultadosRodadas[0]) != vencedor(resultadosRodadas[1])
          && empatouRodada(resultadosRodadas[2])) {
      return vencedor(resultadosRodadas[0]);
    }
  }

  // Verifica se há pelo menos duas rodadas
  if (resultadosRodadas.length >= 2) {
    // Verifica se o jogador empatou na primeira rodada e ganhou na segunda
    if (empatouRodada(resultadosRodadas[0])) {
      // Se o jogador empatou na primeira rodada e ganhou na segunda
      if (!empatouRodada(resultadosRodadas[1])) {
        // Retorna o vencedor da segunda rodada
        return vencedor(resultadosRodadas[1]);
      }
    } else {
      // Se o jogador não empatou na primeira rodada
      // Verifica se o jogador empatou na segunda rodada
      if (empatouRodada(resultadosRodadas[1])) {
        // Retorna o vencedor da primeira rodada
        return vencedor(resultadosRodadas[0]);
      } else if (vencedor(resultadosRodadas[0]) != vencedor(resultadosRodadas[1])) {
        // Se houver um vencedor diferente em cada rodada
        // Verifica se o mesmo jogador venceu pelo menos duas rodadas consecutivas
        for (var i = 2; i < resultadosRodadas.length; i++) {
          if (vencedor(resultadosRodadas[i - 1]) == vencedor(resultadosRodadas[i])) {
            // Se o jogador venceu pelo menos duas rodadas consecutivas
            return vencedor(resultadosRodadas[i]);
          }
        }
        // Se não houver vitórias consecutivas, retorna empate
        return null;
      } else {
        // Se o mesmo jogador venceu as duas rodadas
        return vencedor(resultadosRodadas[0]);
      }
    }
  }

  // Se não houver resultados suficientes para determinar um vencedor
  // Retorna null
  return null;
}

