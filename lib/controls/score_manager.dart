class Pontuacao {
  int pontos = 0;
  int pontuacaoTotal = 0;
  int pontosTruco = 0;
  int pontuacaoAtual = 0;
  List<int> roundResults = [];

  void adicionarPonto() {
    pontos++;
  }

  int getPontos() {
    return pontos;
  }

  void adicionarPontuacaoTotalTruco(int pontosTruco) {
    pontuacaoTotal += pontosTruco;
    print('Pontuação total de truco adicionada: $pontosTruco');
    print('Pontuação total agora é: $pontuacaoTotal');
  }

  void adicionarPontuacaoAtual(int pontosTruco) {
    pontuacaoAtual += pontosTruco;
    print('Pontuação atual: $pontuacaoAtual');
  }

  void adicionarPontuacaoTotal() {
    pontuacaoTotal += 1;
    print('Pontuação total atualizada: $pontuacaoTotal');
  }

  int getPontuacaoTotal() {
    return pontuacaoTotal;
  }

  void adicionarResultadoRodada(int resultado) {
    roundResults.add(resultado);
    print('Resultados das rodadas atualizados: $roundResults');
  }

  List<int> getResultadosRodadas() {
    print('Resultados getResultadosRodadas: $roundResults');
    return roundResults;
  }

  void reiniciarPontos() {
    pontos = 0;
  }

  void reiniciarResultadosRodadas() {
    roundResults.clear();
  }
}
