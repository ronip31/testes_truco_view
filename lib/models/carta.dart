class Carta {
  // Atributos da classe Carta
  String valor; // Valor da carta (ex: "A", "2", "3", etc.)
  String naipe; // Naipe da carta (ex: "Copas", "Espadas", etc.)
  bool ehManilha; // Indica se a carta é uma manilha
  int valorManilha; // Valor da manilha, se for o caso
  bool escondida; // Indica se a carta está escondida

  // Construtor da classe Carta
  Carta({
    required this.valor,
    required this.naipe,
    this.ehManilha = false,
    this.escondida = false,
  }) : valorManilha = 0; // Inicializa o valorManilha como 0

  // Método getter para a imagem da carta
  String get img {
    if (escondida) {
      return 'assets/imgs/fundocarta.jpg'; // Retorna a imagem de fundo se a carta estiver escondida
    }
    return 'assets/imgs/$valor.$naipe.png'; // Retorna a imagem correspondente ao valor e naipe da carta
  }

  // Método para converter o objeto Carta para uma string
  @override
  String toString() {
    return '$valor,$naipe,$ehManilha,$valorManilha,$escondida';
  }

  // Método estático para criar um objeto Carta a partir de uma string
  static Carta fromString(String cartaStr) {
    var parts = cartaStr.split(',');
    return Carta(
      valor: parts[0],
      naipe: parts[1],
      ehManilha: parts[2] == 'true',
      escondida: parts[4] == 'true',
    );
  }

  // Método para converter o valor da carta em um inteiro
  int valorToInt() {
    if (escondida) {
      return -1; // Retorna -1 se a carta estiver escondida
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

  // Método para atribuir pontos de manilha às cartas
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

  // Método para esconder a carta
  void esconder() {
    escondida = true;
    valor = 'ESCONDIDA'; // Define um valor especial para cartas escondidas
  }

  // Getter para o valor de comparação da carta
  int get valorParaComparacao {
    if (escondida) {
      return -1; // Retorna -1 se a carta estiver escondida
    }
    return ehManilha ? valorManilha : valorToInt(); // Retorna o valor da manilha ou o valor da carta
  }
}
