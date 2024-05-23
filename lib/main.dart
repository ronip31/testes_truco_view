import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'models/carta.dart';
import 'models/jogador.dart';
import 'widgets/mao_jogador_widget.dart';
import 'jogo.dart';
import 'models/baralho.dart';
import 'ResultadoRodada.dart';
import 'game.dart';
import 'widgets/JogoTrucoScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo de Truco',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: JogoTrucoScreen(),
    );
  }
}



class JogoTrucoScreen extends StatefulWidget {
  @override
  _JogoTrucoScreenState createState() => _JogoTrucoScreenState();
}

class _JogoTrucoScreenState extends State<JogoTrucoScreen> {
  List<Jogador> jogadores = [];
  int jogadorAtualIndex = 0;
  List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];
  List<Carta> cartasJaJogadas = [];
  List<ResultadoRodada> resultadosRodadas = [];
  Jogador? jogadorVencedor;
  int numeroRodada = 1;
  String resultadoRodada = '';
  bool jogoContinua = true;
  Carta? manilha;

  @override
  void initState() {
    super.initState();
    iniciarJogo();
  }

  void iniciarJogo() {
    jogadores = Jogador.criarJogadores(['Jogador 1', 'Jogador 2'], 2);
    reiniciarRodada();
  }

  void reiniciarRodada() {
    setState(() {
      // Chama finalizarRodada para definir a manilha
      finalizarRodada(jogadores, Baralho(), 2, resultadosRodadas);
      manilha = manilhaGlobal;
      jogadores.forEach((jogador) => jogador.obterCartaDaMao());
      cartasJogadasNaMesa.clear();
      cartasJaJogadas.clear();
      resultadoRodada = '';
      jogadorAtualIndex = 0;
    });
  }

  void jogarCarta(Carta carta) {
    setState(() {
      adicionarCartaNaMesa(carta);
      removerCartaDaMao(carta);
      atualizarJogadorAtual();

      if (todosJogadoresJogaramUmaCarta()) {
        processarFimDaRodada();
      }
    });
  }

  void adicionarCartaNaMesa(Carta carta) {
    cartasJaJogadas.add(carta);
    cartasJogadasNaMesa.add(Tuple2(
      jogadores[jogadorAtualIndex],
      {
        'carta': carta,
        'valor': carta.ehManilha ? carta.valorManilha : carta.valorToInt(),
      },
    ));
  }

  void removerCartaDaMao(Carta carta) {
    jogadores[jogadorAtualIndex].mao.remove(carta);
  }

  void atualizarJogadorAtual() {
    jogadorAtualIndex = (jogadorAtualIndex + 1) % jogadores.length;
  }

  bool todosJogadoresJogaramUmaCarta() {
    return cartasJogadasNaMesa.length == jogadores.length;
  }

  void processarFimDaRodada() {
    jogadorVencedor = compararCartas(cartasJogadasNaMesa);
    mostrarResultadoRodada(jogadorVencedor);
    resultadosRodadas.add(ResultadoRodada(numeroRodada, jogadorVencedor));
    verificarVencedorDoJogo(resultadosRodadas);
  }

  void mostrarResultadoRodada(Jogador? jogadorVencedor) {
    setState(() {
      resultadoRodada = jogadorVencedor != null
          ? 'O ${jogadorVencedor.nome} ganhou a rodada!'
          : 'Empate! Ninguém ganhou a rodada.';
      cartasJogadasNaMesa.clear();
    });
  }

  void verificarVencedorDoJogo(resultadosRodadas) {
    Jogador? vencedorJogo = determinarVencedor(resultadosRodadas);
    if (vencedorJogo != null) {
      print('\n\rO vencedor do jogo é o jogador ${vencedorJogo.nome} e do grupo ${vencedorJogo.grupo}');
      
      vencedorJogo.adicionarPontuacaoTotal();

      for (var jogador in jogadores) {
        int pontuacaoTotal = jogador.getPontuacaoTotal();
        print('\n\rPontuação total do grupo ${jogador.grupo} é de: $pontuacaoTotal');
        resultadoRodada ='\n\rPontuação total do grupo ${jogador.nome} é de: $pontuacaoTotal';
        // Verifica se algum jogador atingiu a pontuação total desejada
        if (pontuacaoTotal >= 5) {
          // Encerra o jogo
          print('\nO Grupo ${jogador.grupo} atingiu a pontuação máxima de 5 pontos e ganhou o jogo!');
          resultadoRodada = '\nO Grupo ${jogador.grupo} atingiu a pontuação máxima de 5 pontos e ganhou o jogo!';
          jogoContinua = false;
          break; // Sai do loop, já que o jogo será encerrado
        }
      }
 
    // Se o jogo foi encerrado
    if (jogoContinua) {
      // Chama o método para iniciar a próxima rodada
      Future.delayed(Duration(seconds: 10), (){
      reiniciarRodada();
    });
    }
  }
}

  void reiniciarJogo() {
    setState(() {
      jogadores = Jogador.criarJogadores(['Jogador 1', 'Jogador 2'], 2);
      resultadosRodadas.clear();
      jogadorVencedor = null;
      numeroRodada = 1;
      resultadoRodada = '';
      jogoContinua = true;
      reiniciarRodada();
    });
  }

  @override
  Widget build(BuildContext context) {
    return JogoTrucoLayout(
      jogadores: jogadores,
      jogadorAtualIndex: jogadorAtualIndex,
      resultadoRodada: resultadoRodada,
      cartasJaJogadas: cartasJaJogadas,
      manilha: manilha,
      onCartaSelecionada: (index) {
        if (index >= 0 && index < jogadores[jogadorAtualIndex].mao.length) {
          var cartaSelecionada = jogadores[jogadorAtualIndex].mao[index];
          jogarCarta(cartaSelecionada);
        }
      },
    );
  }
}
