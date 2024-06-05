class Carta {
  final String valor;
  final String naipe;
  bool ehManilha;
  int valorManilha;

  Carta({
    required this.valor,
    required this.naipe,
    this.ehManilha = false,
  }) : valorManilha = 0;

  String get img => 'assets/imgs/$valor.$naipe.png';

  @override
  String toString() {
    return '{$valor,$naipe}';
  }

  int valorToInt() {
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
}


