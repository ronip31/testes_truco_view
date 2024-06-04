import 'package:tuple/tuple.dart';
import '../models/carta.dart';
import '../controls/pedir_truco.dart';

class Jogador {
  Truco truco = Truco();
  
  late String nome;
  List<Carta> mao = [];
  List<int> indicesSelecionados = [];
  int pontos = 0;
  int pontuacaoTotal = 0;
  int grupo;
  int pontosTruco = 0;
  List<Carta> mesa = [];
  List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];
  Set<Carta> cartasJaJogadas = {}; 

  Jogador(this.nome, this.grupo): mao = [];

  // Método de fábrica para criar jogadores a partir de uma lista de nomes
  static List<Jogador> criarJogadores(List<String> nomes, int numeroGrupos) {
    List<Jogador> jogadores = [];
    int grupoAtual = 1;

    for (int i = 0; i < nomes.length; i++) {
      jogadores.add(Jogador(nomes[i], grupoAtual));
      grupoAtual = (grupoAtual % numeroGrupos) + 1;  // Alterna entre 1 e 2

      for (Jogador jogador in jogadores) {
        print('jogador.nome ${jogador.nome} e Grupo: ${jogador.grupo}');
      }
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

  void adicionarPonto() {
    pontos++;
  }

  int getPontos() {
    return pontos;
  }

  void adicionarPontuacaoTotalTruco(int pontosTruco) {
    pontuacaoTotal += pontosTruco;
    print('pontuacaoTotal = $pontuacaoTotal');
  }

  void adicionarPontuacaoTotal() {
    pontuacaoTotal += 1;
    print('pontuacaoTotal = $pontuacaoTotal');
  }


  int getPontuacaoTotal() {
    return pontuacaoTotal;
  }

  void reiniciarPontos() {
    pontos = 0;
  }
}