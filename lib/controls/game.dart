import 'package:tuple/tuple.dart';
import '../models/jogador.dart';
import '../../models/carta.dart';
import 'resultado_rodada.dart';
import '../models/baralho.dart';

List<Carta> mesa = [];

Jogador? compararCartas(List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa) {
    if (cartasJogadasNaMesa.isEmpty) {
      return null; // Se não houver cartas jogadas na mesa, não há vencedor
    }

    // Inicializa a carta vencedora com a primeira carta jogada
    var cartaVencedora = cartasJogadasNaMesa[0];
    

    // Percorre as cartas jogadas na mesa a partir da segunda carta
    for (var i = 1; i < cartasJogadasNaMesa.length; i++) {
      var cartaJogada = cartasJogadasNaMesa[i];
      var valorCarta = cartaJogada.item2['valor'];
      var valorCartaVencedora = cartaVencedora.item2['valor'];
      
      print('cartasJogadasNaMesa $cartasJogadasNaMesa');
      // Se o valor da carta atual for maior que o da carta vencedora atual,
      // atualiza a carta vencedora para a carta atual
      if (valorCarta > valorCartaVencedora) {
        cartaVencedora = cartaJogada;
      }
      // Se houver um empate, retorna null
      else if (valorCarta == valorCartaVencedora) {
        return null;
      }
    }
    // Retorna o jogador associado à carta vencedora
    return cartaVencedora.item1;
  }


  Carta? manilhaGlobal;
  void finalizarRodada(List<Jogador> jogadores, Baralho baralho, int numeroJogadores, resultadosRodadas) {

  for (var jogador in jogadores) {
      jogador.limparIndicesSelecionados();
    }

    // Limpa a mesa para a próxima rodada
    mesa.clear();

    

    // Limpa os resultados das rodadas
    limparResultadosRodadas(resultadosRodadas);
  // Limpa as mãos dos jogadores
  for (var jogador in jogadores) {
    jogador.mao = []; // Atribui uma lista vazia para limpar a mão do jogador
  }

  baralho.embaralhar();

  // Distribui as cartas para os jogadores
  List<List<Carta>> todasMaosJogadores = baralho.distribuirCartasParaJogadores(numeroJogadores);

  // Atualiza as mãos dos jogadores
  for (int i = 0; i < jogadores.length; i++) {
    jogadores[i].mao = todasMaosJogadores[i];
  }

  // Define a última carta virada como manilha
  baralho.cartas[0].ehManilha = true;

  // Define qual carta será virada na mesa
  manilhaGlobal = baralho.cartas.firstWhere((carta) => carta.ehManilha);

  print('\nA manilha VIRADA é: $manilhaGlobal');

  // Define as manilhas reais, que poderão estar nas mãos dos jogadores
  List<Carta> manilhasReais = baralho.definirManilhaReal(manilhaGlobal!);

  //print('\nManilhas REAIS são: $manilhasReais \n');

  // Atribui pontos de manilha para todas as cartas do baralho
  for (var carta in baralho.cartas) {
    carta.atribuirPontosManilha(manilhasReais);
  }

  // Atribui pontos de manilha para todas as mãos de jogadores
  for (var maosJogador in todasMaosJogadores) {
    for (var carta in maosJogador) {
      carta.atribuirPontosManilha(manilhasReais);
    }
  }
}

  void limparResultadosRodadas(List<ResultadoRodada> resultadosRodadas) {
    resultadosRodadas.clear();
  }
