import '../models/carta.dart';

class Baralho {
  final  List<Carta> _cartas = [];
  final naipes = ['Paus', 'Copas', 'Espadas', 'Ouros'];
  final valores = ['2', '3', '4', '5', '6', '7', 'Q', 'J', 'K', 'A'];

  // Cria o baralho com todas opções de cartas
  Baralho() {
    for (final naipe in naipes) {
      for (final valor in valores) {
        _cartas.add(Carta(
          valor: valor,
          naipe: naipe,
        ));
      }
    }
  }

  // Embaralha as cartas, garante aleatoriedade nas cartas.
  void embaralhar() {
    _cartas.shuffle();
  }

  List<Carta> definirManilhaReal(Carta cartaVirada) {
    int valorManilhaVirada = cartaVirada.valorToInt();
    int valorProximaManilha = (valorManilhaVirada + 1) % 11;

    if (valorManilhaVirada == 10) {
      valorProximaManilha = 1;
    }

    List<Carta> manilhasReais = [];

    for (var valor in valores) {
      for (var naipe in naipes) {
        var cartaPossivel = Carta(
          valor: valor,
          naipe: naipe,
        );
        if (cartaPossivel.valorToInt() == valorProximaManilha) {
          manilhasReais.add(cartaPossivel);
          // Atribuir pontos de manilha à carta
          cartaPossivel.atribuirPontosManilha(manilhasReais);
        }
      }
    }

    return manilhasReais;
  }

  // Distribui as cartas, e garante que as cartas distribuídas sejam retiradas do baralho
  List<Carta> distribuirCartas(int quantidade) {
    List<Carta> cartasDistribuidas = [];
    for (var i = 0; i < quantidade; i++) {
      if (_cartas.isEmpty) {
        print('O baralho está vazio!');
        break;
      }
      cartasDistribuidas.add(_cartas.removeAt(0));
    }
    return cartasDistribuidas;
  }

  // Campo _cartas é privado, para a classe main acessar é necessário esse método getter 
  List<Carta> get cartas => _cartas;

  // Função para distribuir cartas para um número especificado de jogadores
  List<List<Carta>> distribuirCartasParaJogadores(int numeroJogadores) {
    List<List<Carta>> todasMaosJogadores = [];
    for (var i = 0; i < numeroJogadores; i++) {
      List<Carta> maoJogador = distribuirCartas(3);
      todasMaosJogadores.add(maoJogador);
    }
    return todasMaosJogadores;
  }
}
