import 'package:tuple/tuple.dart';
import '../models/carta.dart';
import '../controls/pedir_truco.dart';
import '../controls/score_manager.dart';

class Jogador {
  Truco truco = Truco();
  
  late String nome;
  List<Carta> mao = [];
  List<int> indicesSelecionados = [];
  int grupo;
  List<Carta> mesa = [];
  List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];
  Set<Carta> cartasJaJogadas = {};
  Pontuacao pontuacao = Pontuacao();
  int playerId; // Adiciona a propriedade playerId

  Jogador(this.nome, this.grupo, this.playerId): mao = [];

  // Método de fábrica para criar jogadores a partir de uma lista de nomes
  static List<Jogador> criarJogadores(List<String> nomes, int numeroGrupos) {
    List<Jogador> jogadores = [];
    int grupoAtual = 1;

    for (int i = 0; i < nomes.length; i++) {
      jogadores.add(Jogador(nomes[i], grupoAtual, i + 1)); // Define o playerId
      grupoAtual = (grupoAtual % numeroGrupos) + 1;  // Alterna entre 1 e 2
    }

    for (Jogador jogador in jogadores) {
      print('Jogador: ${jogador.nome} do Grupo: ${jogador.grupo} com playerId: ${jogador.playerId}');
    }

    return jogadores;
  }

  void obterCartaDaMao() {
    print('\nCartas na mão do $nome:');
    for (var i = 0; i < mao.length; i++) {
        if (!indicesSelecionados.contains(i)) {
            var carta = mao[i];
            var valor = carta.ehManilha ? carta.valorManilha : carta.valorToInt();
            print('${i + 1} $carta - Valor: $valor${carta.ehManilha ? ' (M)' : ''}');
        }
    }
  }

  // Método para limpar a lista de índices das cartas selecionadas
  void limparIndicesSelecionados() {
    indicesSelecionados.clear();
  }
}
