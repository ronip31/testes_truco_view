import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import '../models/baralho.dart';
import 'resultado_rodada.dart';
import 'game.dart';
import '../interface_user/user_interface.dart';
import 'pedir_truco.dart';
import 'truco_manager.dart';
import '../controls/score_manager.dart';

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
  OverlayEntry? _overlayEntry;
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
    print('cartasJaJogadas : $cartasJaJogadas');
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

      print("Results updated: $roundResults");

      resultadoRodada = jogadorVencedor != null
          ? 'O ${jogadorVencedor.nome} ganhou a rodada!'
          : 'Empate!';
      rodadacontinua = false;
      _showPopup(resultadoRodada);
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
          _showPopup(resultadoRodada);
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

  void _showPopup(String message) {
    _overlayEntry = _createOverlayEntry(message);
    Overlay.of(context).insert(_overlayEntry!);
    Future.delayed(const Duration(seconds: 1), () {
      _overlayEntry?.remove();
      rodadacontinua = true;
    });
  }

  OverlayEntry _createOverlayEntry(String message) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 3,
        left: MediaQuery.of(context).size.width / 4,
        width: MediaQuery.of(context).size.width / 2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
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

  void _showEsconderMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Escolha uma carta para esconder ou clique em cancelar'),
        action: SnackBarAction(
          label: 'Cancelar',
          onPressed: () {
            setState(() {
              escondendoCarta = false;
            });
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
