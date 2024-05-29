import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import '../models/baralho.dart';
import '../resultado_rodada.dart';
import '../game.dart';
import 'truco_layout.dart';
import '../pedir_truco.dart';

class JogoTrucoScreen extends StatefulWidget {
  final List<Carta> cartas;

  const JogoTrucoScreen({super.key, required this.cartas});

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
  bool rodadacontinua = true; // False bloqueia as cartas restantes da mão dos jogadores
  Carta? manilha;
  OverlayEntry? _overlayEntry;
  Truco truco = Truco();

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
      rodadacontinua = true;
      jogadorVencedor = null;
      cartasJaJogadas.clear();
      finalizarRodada(jogadores, Baralho(), 2, resultadosRodadas); // Passa as cartas carregadas para o Baralho
      manilha = manilhaGlobal;
      for (var jogador in jogadores) {
        jogador.obterCartaDaMao();
      }
      cartasJogadasNaMesa.clear();
      resultadoRodada = '';
      jogadorAtualIndex = 0;
      truco.jogadorQuePediuTruco = null;  // Resetar quem pediu truco ao iniciar uma nova rodada
    });
  }

  void jogarCarta(Carta carta) {
    if (!rodadacontinua) return;
    setState(() {
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
          : 'Empate!';
      rodadacontinua = false;
      _showPopup(resultadoRodada);
    });

    // Limpa as cartas jogadas na mesa após mostrar o resultado e reinicia a rodada
    Future.delayed(const Duration(seconds: 2), () {
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

      // resultadoRodada = '\nO Grupo ${vencedorJogo.nome} GANHOU  RODADA!';
      //     _showPopup(resultadoRodada);

      vencedorJogo.adicionarPontuacaoTotal();

      for (var jogador in jogadores) {
        int pontuacaoTotal = vencedorJogo.getPontuacaoTotal();

        if (pontuacaoTotal >= 12) {
          resultadoRodada = '\nO Grupo ${jogador.nome} GANHOU jogo!';
          _showPopup(resultadoRodada);
          
          break;
        }
      }

      if (jogoContinua) {
        Future.delayed(const Duration(seconds: 5), (){
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
    Future.delayed(const Duration(seconds: 2), () {
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
      rodadacontinua: rodadacontinua,
      cartas: widget.cartas, 
    );
  }
}
