class Pontuacao {
  int pontos = 0;
  int pontuacaoTotal = 0;
  int pontosTruco = 0;
  int pontuacaoAtual = 0;
  List<int> roundResults = [];  // Lista para armazenar os resultados das rodadas

  // Adiciona um ponto
  void adicionarPonto() {
    pontos++;
  }

  // Retorna a quantidade de pontos
  int getPontos() {
    return pontos;
  }

  // Adiciona a pontuação do truco à pontuação total
  void adicionarPontuacaoTotalTruco(int pontosTruco) {
    pontuacaoTotal += pontosTruco;
    print('Pontuação total de truco adicionada: $pontosTruco');
    print('Pontuação total agora é: $pontuacaoTotal');
  }

  // Adiciona a pontuação atual
  void adicionarPontuacaoAtual(int pontosTruco) {
    pontuacaoAtual += pontosTruco;
    print('Pontuação atual: $pontuacaoAtual');
  }

  // Adiciona 1 ponto à pontuação total
  void adicionarPontuacaoTotal() {
    pontuacaoTotal += 1;
    print('Pontuação total atualizada: $pontuacaoTotal');
  }

  // Retorna a pontuação total
  int getPontuacaoTotal() {
    return pontuacaoTotal;
  }

  // Adiciona o resultado de uma rodada
  void adicionarResultadoRodada(int resultado) {
    roundResults.add(resultado);
    print('Resultados das rodadas atualizados: $roundResults');
  }

  // Retorna os resultados das rodadas
  List<int> getResultadosRodadas() {
    print('Resultados getResultadosRodadas: $roundResults');
    return roundResults;
  }

  // Reinicia os pontos
  void reiniciarPontos() {
    pontos = 0;
  }

  // Reinicia os resultados das rodadas
  void reiniciarResultadosRodadas() {
    roundResults.clear();
  }
}
