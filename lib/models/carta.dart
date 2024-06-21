class Carta {
  String valor;
  String naipe;
  bool ehManilha;
  int valorManilha;
  bool escondida;

  Carta({
    required this.valor,
    required this.naipe,
    this.ehManilha = false,
    this.escondida = false,
  }) : valorManilha = 0;

  String get img {
    if (escondida) {
      return 'assets/imgs/fundocarta.jpg';
    }
    return 'assets/imgs/$valor.$naipe.png';
  }

  @override
  String toString() {
    return '$valor,$naipe,$ehManilha,$valorManilha,$escondida';
  }

  static Carta fromString(String cartaStr) {
    var parts = cartaStr.split(',');
    return Carta(
      valor: parts[0],
      naipe: parts[1],
      ehManilha: parts[2] == 'true',
      escondida: parts[4] == 'true',
    );
  }

  int valorToInt() {
    if (escondida) {
      return -1;
    }
    switch (valor) {
      case '3':
        return 10;
      case '2':
        return 9;
      case 'A':
        return 8;
      case 'K':
        return 7;
      case 'J':
        return 6;
      case 'Q':
        return 5;
      case '7':
        return 4;
      case '6':
        return 3;
      case '5':
        return 2;
      case '4':
        return 1;
      default:
        return 0;
    }
  }

  void atribuirPontosManilha(List<Carta> manilhasReais) {
    for (var manilha in manilhasReais) {
      if (manilha.valor == valor && manilha.naipe == naipe) {
        ehManilha = true;
        switch (manilha.naipe) {
          case 'Paus':
            valorManilha = 14;
            break;
          case 'Copas':
            valorManilha = 13;
            break;
          case 'Espadas':
            valorManilha = 12;
            break;
          case 'Ouros':
            valorManilha = 11;
            break;
        }
      }
    }
  }

  void esconder() {
    escondida = true;
    valor = 'ESCONDIDA'; // Define um valor especial para cartas escondidas
  }

  int get valorParaComparacao {
    if (escondida) {
      return -1;
    }
    return ehManilha ? valorManilha : valorToInt();
  }
}
