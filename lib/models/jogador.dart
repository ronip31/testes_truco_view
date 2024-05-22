import 'package:tuple/tuple.dart';
import 'dart:io';
import '../models/carta.dart';
import '../pedirTruco.dart';

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
    for (int i = 0; i < nomes.length; i++) {
      int grupo = (i < numeroGrupos) ? 1 : 1;
      jogadores.add(Jogador(nomes[i], grupo));
    }
    return jogadores;
  }

  void obterCartaDaMao() {
    if (mao.isEmpty) {
        print('A mão de $nome está vazia!');
        return null;
    }

    print('\nCartas na mão do $nome:');
    for (var i = 0; i < mao.length; i++) {
        if (!indicesSelecionados.contains(i)) {
            var carta = mao[i];
            var valor = carta.ehManilha ? carta.valorManilha : carta.valorToInt();
            print('${i + 1} ${carta} - Valor: $valor${carta.ehManilha ? ' (M)' : ''}');
        }
    }
  }

  Tuple4<Jogador, Jogador?, int, int>? acaoDoJogador(Jogador jogador, List<Jogador> jogadores) {
  while (true) {
    stdout.write('O jogador ${jogador.nome}, do Grupo: ${jogador.grupo} escolha a carta que deseja jogar (índice), ou "T" para pedir truco: ');
    String? input = stdin.readLineSync();
    
    if (input == null) {
      print('Entrada inválida. Tente novamente.');
      continue;
    }

    if (input.toUpperCase() == 'T') {
      // Verifica se o truco já foi aceito
      if (truco.trucoFoiAceito) {
          print('Você já pediu truco e ele foi aceito. Não é possível realizar outra ação.');
          continue;
      }
      //CRIAR VALIDAÇÃO PARA NÃO PERMITIR PEDIR TRUCO SE JÁ FOI PEDIDO NA RODADA, SOMENTE AUMENTAR
      // Chama o método pedirTruco e recebe o retorno
      Tuple4<Jogador, Jogador?, int, int>? infoTruco = pedirTruco(jogador, jogadores);
      
      // Verifica se o retorno do método pedirTruco é diferente de null
      if (infoTruco != null) {
          print('infoTruco da função pedir truco: ${infoTruco}');
          // Retorna apenas os elementos necessários da tupla retornada pelo pedirTruco
          return infoTruco;
      }
      
      // Retorna null caso o método pedirTruco retorne null
      continue;
      }

      int indice;
      try {
        indice = int.parse(input);
      } catch (e) {
        print('Entrada inválida. Tente novamente.');
        continue;
      }

      // Verifica se o índice é válido
      if (indice < 1 || indice > jogador.mao.length) {
        print('Índice inválido. Escolha um índice entre 1 e ${jogador.mao.length}.');
        continue;
      }

      // Verifica se o índice já foi jogado
      if (indice < 1 || indice > mao.length || indicesSelecionados.contains(indice - 1)) {
        print('Este índice já foi jogado. Escolha um índice diferente.');
        continue;
      }

      indicesSelecionados.add(indice - 1);
      var cartaSelecionada = mao[indice - 1];
      var valorCarta = cartaSelecionada.ehManilha ? cartaSelecionada.valorManilha : cartaSelecionada.valorToInt();

      print('Ação do jogador: ${valorCarta}, carta selecionada: ${cartaSelecionada}');
      // Retorna as informações sobre a carta selecionada
      return Tuple4<Jogador, Jogador?, int, int>(jogador, null, valorCarta, pontosTruco);
    }
  }


Tuple4<Jogador, Jogador?, int, int>? selecionarCarta(Jogador jogador, int indice) {
  print('${jogador}, ${indice}');
  
  if (indice < 1 || indice > jogador.mao.length || jogador.indicesSelecionados.contains(indice - 1)) {
    print('Índice inválido ou carta já jogada! Escolha um índice válido.');
    return null;
  }

  //jogador.indicesSelecionados.add(indice - 1);
  var cartaSelecionada = jogador.mao[indice];
  var valorCarta = cartaSelecionada.ehManilha ? cartaSelecionada.valorManilha : cartaSelecionada.valorToInt();
  
  print('selecionarCarta: ${valorCarta} cartaSelecionada: ${cartaSelecionada}');
  return Tuple4<Jogador, Jogador?, int, int>(jogador, null, valorCarta, 0);
}




Tuple4<Jogador, Jogador?, int, int>? pedirTruco(Jogador jogador, List<Jogador> jogadores) {
  // Determina qual jogador está pedindo truco e qual está respondendo
  Jogador jogadorQuePediuTruco = jogador;
  Jogador jogadorQueRespondeTruco = jogadores.firstWhere((element) => element != jogadorQuePediuTruco);

  // Cria uma instância da classe Truco e chama o método pedirTruco
  Truco truco = Truco();
  return truco.pedirTruco(jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
  
}

  

  // Método para limpar a lista de índices das cartas selecionadas
  void limparIndicesSelecionados() {
    indicesSelecionados.clear();
  }

  void jogarCarta(List<Carta> mesa, Carta carta) {
    mesa.add(carta);
    print('$nome jogou a carta: $carta');
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

  String? escolherAcao() {
    print('\n$nome, escolha a ação desejada:');
    print('1. Jogar uma carta');
    print('2. Pedir truco');
    stdout.write('Opção: ');
    String? escolha = stdin.readLineSync();
    return escolha;
  }

   bool responderTruco(Jogador jogadorQuePediuTruco, int pontosTruco) {
    print('${jogadorQuePediuTruco.nome} pediu truco! Você aceita? (S/N)');
    String? resposta = stdin.readLineSync()?.toUpperCase();
    return resposta == 'S';
  }

}