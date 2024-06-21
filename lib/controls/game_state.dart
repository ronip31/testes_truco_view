import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String roomId;
  final String playerName;

  const JogoTrucoScreen({Key? key, required this.roomId, required this.playerName}) : super(key: key);

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
  bool gameReady = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId);

    roomRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final List<dynamic> players = data['players'];
        print('players: $players');
        if (players.length == 2 && jogadores.isEmpty) {
          setState(() {
            jogadores = Jogador.criarJogadores(players.cast<String>(), 2);
            _loadGameState(data['gameState']);
          });
        }
      }
    });
  }

  void _loadGameState(Map<String, dynamic> gameState) {
    setState(() {
      manilha = Carta.fromString(gameState['manilha']);
      jogadores[0].mao = (gameState['cartasJogador1'] as List).map((cartaStr) => Carta.fromString(cartaStr)).toList();
      jogadores[1].mao = (gameState['cartasJogador2'] as List).map((cartaStr) => Carta.fromString(cartaStr)).toList();
      gameReady = true;
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
    _syncGameState();
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
          ? 'O ${jogadorVencedor!.nome} ganhou a rodada!'
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
    _syncGameState();
  }

  void verificarVencedorDoJogo(List<ResultadoRodada> resultadosRodadas) {
    Jogador? vencedorJogo = determinarVencedor(resultadosRodadas);
    if (vencedorJogo != null) {
      rodadacontinua = false;

      trucoManager.adicionarPontuacaoAoVencedor(vencedorJogo);

      for (var jogador in jogadores) {
        int pontuacaoTotal = vencedorJogo!.pontuacao.getPontuacaoTotal();

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

  void reiniciarRodada() {
    setState(() {
      resultadosRodadas.clear();
      jogadorVencedor = null;
      numeroRodada = 1;
      resultadoRodada = '';
      jogoContinua = true;
      rodadacontinua = true;
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
    _syncGameState();
  }

  void _syncGameState() {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId);
    roomRef.update({
      'gameState': {
        'jogadorAtualIndex': jogadorAtualIndex,
        'cartasJogadasNaMesa': cartasJogadasNaMesa.map((e) => {
          'jogador': e.item1.nome,
          'carta': e.item2['carta'].toString(),
          'valor': e.item2['valor']
        }).toList(),
        'cartasJaJogadas': cartasJaJogadas.map((carta) => carta.toString()).toList(),
        'resultadosRodadas': resultadosRodadas.map((resultado) => {
          'numeroRodada': resultado.numeroRodada,
          'jogadorVencedor': resultado.jogadorVencedor?.nome
        }).toList(),
        'rodadacontinua': rodadacontinua,
        'resultadoRodada': resultadoRodada,
        'roundResults': roundResults
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!gameReady) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Aguardando o início do jogo...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final jogadorAtual = widget.playerName == jogadores[0].nome ? jogadores[0] : jogadores[1];

    return JogoTrucoLayout(
      jogadorAtual: jogadorAtual,
      jogadores: jogadores,
      resultadoRodada: resultadoRodada,
      cartasJaJogadas: cartasJaJogadas,
      manilha: manilha,
      pontuacao: pontuacao,
      onCartaSelecionada: (index) {
        if (index >= 0 && index < jogadorAtual.mao.length) {
          var cartaSelecionada = jogadorAtual.mao[index];
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
