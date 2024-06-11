class Pontuacao {
  int pontos = 0;
  int pontuacaoTotal = 0;
  int pontosTruco = 0;

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