import 'package:tuple/tuple.dart';
import 'valorCarta.dart';
import 'models/baralho.dart'; 
import 'consoles.dart';
import 'models/jogador.dart';
import 'jogo.dart';

void main() {

  List<String> nomesDosJogadores = obterNomesDosJogadores(); // Função que obtem os nomes dos jogadores
  int? numeroJogadores = obterNumeroJogadores();
  print('Número de jogadores selecionado: $numeroJogadores');
  int numeroGrupos = (numeroJogadores / 2).toInt();

  // Pergunta ao usuário quantos jogadores deseja
  

  // Cria o baralho
  Baralho baralho = Baralho();

  Jogo jogo = Jogo();

  // Cria os jogadores
  List<Jogador> jogadores = Jogador.criarJogadores(nomesDosJogadores, numeroGrupos);

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
  jogo.iniciarJogo(jogadores, numeroJogadores,  gruposDeJogadores);
  
}

// Função para obter os nomes dos jogadores
List<String> obterNomesDosJogadores() {
  // Implemente a lógica para obter os nomes dos jogadores (ex: via console ou entrada do usuário)
  return ['Jogador1', 'Jogador2'];
}