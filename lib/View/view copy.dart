import 'package:tuple/tuple.dart';

import '../models/baralho.dart'; 
import '../consoles.dart';
import '../models/jogador.dart';
import '../jogo.dart';


class FlutterIntegration {
  static List<Jogador> iniciarJogoComJogadores(List<String> nomesDosJogadores) {
    int numeroJogadores = nomesDosJogadores.length;
    int numeroGrupos = (numeroJogadores / 2).toInt();

    // Cria os jogadores
    List<Jogador> jogadores = Jogador.criarJogadores(nomesDosJogadores, numeroGrupos);

    // Cria o baralho e o jogo
    Baralho baralho = Baralho();
    Jogo jogo = Jogo();

    // Agrupa os jogadores
    List<List<Jogador>> gruposDeJogadores = [];
    for (int i = 0; i < numeroGrupos; i++) {
      gruposDeJogadores.add([
        jogadores[i],
        jogadores[i + numeroGrupos],
      ]);
    }

    // Chamando o método para finalizar a rodada e distribuir novas cartas no início do jogo e ao final de cada rodada
    jogo.finalizarRodada(jogadores, baralho, numeroJogadores);

    // Chamando a função iniciarJogo
    jogo.iniciarJogo(jogadores, numeroJogadores, gruposDeJogadores);

    return jogadores;
  }
}
