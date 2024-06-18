import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import '../models/baralho.dart';
import 'resultado_rodada.dart';
import 'game.dart';
import 'truco_manager.dart';
import '../controls/score_manager.dart';
import '../interface_user/popup_manager.dart';
import '../interface_user/user_interface.dart';
import 'pedir_truco.dart';

class JogoTrucoScreen extends StatefulWidget {
  const JogoTrucoScreen({super.key});

  @override
  JogoTrucoScreenState createState() => JogoTrucoScreenState();
}

class JogoTrucoScreenState extends State<JogoTrucoScreen> {
  List<Jogador> jogadores = [];
  int jogadorAtualIndex = 0;
  List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];
  List<Carta> cartasJaJogadas = [];
  List<ResultadoRodada> resultadosRodadas = [];
  Jogador? jogadorVencedor;
  int numeroRodada = 1;
  String resultadoRodada = '';
  bool jogoContinua = true;
  bool rodadacontinua = true;
  Carta? manilha;
  Truco truco = Truco();
  final TrucoManager trucoManager = TrucoManager();
  Pontuacao pontuacao = Pontuacao();
  List<int> roundResults = [];
  bool escondendoCarta = false;

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
      pontuacao.reiniciarResultadosRodadas();
      trucoManager.limpamap();
      rodadacontinua = true;
      jogadorVencedor = null;
      cartasJaJogadas.clear();
      finalizarRodada(jogadores, Baralho(), 2, resultadosRodadas);
      manilha = manilhaGlobal;
      for (var jogador in jogadores) {
        jogador.obterCartaDaMao();
      }
      cartasJogadasNaMesa.clear();
      resultadoRodada = '';
      jogadorAtualIndex = 0;
    });
  }

  void jogarCarta(Carta carta) {
    if (!rodadacontinua) return;
    setState(() {
      if (escondendoCarta) {
        carta.esconder();
        escondendoCarta = false;
      }
      adicionarCartaNaMesa(carta);
      removerCartaDaMao(carta);
      atualizarJogadorAtual();

      if (todosJogadoresJogaramUmaCarta()) {
        rodadacontinua = false;
        processarFimDaRodada();
      }
    });
  }

  void adicionarCartaNaMesa(Carta carta) {
    if (!rodadacontinua) return;
    cartasJaJogadas.add(carta);
    cartasJogadasNaMesa.add(Tuple2(
      jogadores[jogadorAtualIndex],
      {
        'carta': carta,
        'valor': carta.valorParaComparacao,
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
      int result = jogadorVencedor == null ? 0 : (jogadorVencedor == jogadores[0] ? 1 : 2);
      roundResults.add(result);
      pontuacao.adicionarResultadoRodada(result);

      resultadoRodada = jogadorVencedor != null
          ? 'O ${jogadorVencedor.nome} ganhou a rodada!'
          : 'Empate!';
      rodadacontinua = false;
      PopupManager.showPopup(context, resultadoRodada);
      rodadacontinua = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        cartasJogadasNaMesa.clear();
        cartasJaJogadas.clear();
      });
    });
  }

  void verificarVencedorDoJogo(List<ResultadoRodada> resultadosRodadas) {
    Jogador? vencedorJogo = determinarVencedor(resultadosRodadas);
    if (vencedorJogo != null) {
      rodadacontinua = false;

      trucoManager.adicionarPontuacaoAoVencedor(vencedorJogo);

      for (var jogador in jogadores) {
        int pontuacaoTotal = vencedorJogo.pontuacao.getPontuacaoTotal();

        if (pontuacaoTotal >= 12) {
          resultadoRodada = '\nO Grupo ${jogador.nome} GANHOU o jogo!';
          PopupManager.showPopup(context, resultadoRodada);
          break;
        }
      }

      if (jogoContinua) {
        Future.delayed(const Duration(seconds: 5), () {
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
      rodadacontinua = true;
      reiniciarRodada();
    });
  }

  void esconderCarta(Carta carta) {
    setState(() {
      carta.esconder();
      adicionarCartaNaMesa(carta);
      removerCartaDaMao(carta);
      atualizarJogadorAtual();
      if (todosJogadoresJogaramUmaCarta()) {
        rodadacontinua = false;
        processarFimDaRodada();
      }
    });
  }

  void _showEsconderMessage() {
    PopupManager.showEsconderMessage(context, () {
      setState(() {
        escondendoCarta = false;
      });
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
      pontuacao: pontuacao,
      onCartaSelecionada: (index) {
        if (index >= 0 && index < jogadores[jogadorAtualIndex].mao.length) {
          var cartaSelecionada = jogadores[jogadorAtualIndex].mao[index];
          if (escondendoCarta) {
            esconderCarta(cartaSelecionada);
            escondendoCarta = false;
          } else {
            jogarCarta(cartaSelecionada);
          }
        }
      },
      rodadacontinua: rodadacontinua,
      onEsconderPressed: () {
        setState(() {
          escondendoCarta = true;
        });
        _showEsconderMessage();
      },
    );
  }
}
