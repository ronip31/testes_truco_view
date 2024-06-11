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
  bool rodadacontinua = true; // False bloqueia as cartas restantes da mão dos jogadores
  Carta? manilha;
  OverlayEntry? _overlayEntry;
  Truco truco = Truco();
  final TrucoManager trucoManager = TrucoManager();
  Pontuacao pontuacao = Pontuacao();

  @override
  void initState() {
    super.initState();
    iniciarJogo();
  }

  // Função que inicializa o jogo
  void iniciarJogo() {
    jogadores = Jogador.criarJogadores(['Jogador 1', 'Jogador 2'], 2); // Cria dois jogadores
    reiniciarRodada();
  }

  // Função que reinicia a rodada
  void reiniciarRodada() {
    setState(() {
      trucoManager.limpamap(); // Limpa as informações do truco
      rodadacontinua = true;
      jogadorVencedor = null;
      cartasJaJogadas.clear();
      finalizarRodada(jogadores, Baralho(), 2, resultadosRodadas); // Passa as cartas carregadas para o Baralho
      manilha = manilhaGlobal;
      for (var jogador in jogadores) {
        jogador.obterCartaDaMao(); // Distribui as cartas para os jogadores
      }
      cartasJogadasNaMesa.clear();
      resultadoRodada = '';
      jogadorAtualIndex = 0; // Reseta o índice do jogador atual
    });
  }

  // Função que processa o ato de jogar uma carta
  void jogarCarta(Carta carta) {
    if (!rodadacontinua) return;
    setState(() {
      adicionarCartaNaMesa(carta); // Adiciona a carta jogada na mesa
      removerCartaDaMao(carta); // Remove a carta da mão do jogador
      atualizarJogadorAtual(); // Atualiza o jogador atual

      if (todosJogadoresJogaramUmaCarta()) { // Verifica se todos os jogadores jogaram uma carta
        rodadacontinua = false;
        processarFimDaRodada(); // Processa o fim da rodada
      }
    });
  }

  // Função que adiciona a carta na mesa
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

  // Função que remove a carta da mão do jogador
  void removerCartaDaMao(Carta carta) {
    jogadores[jogadorAtualIndex].mao.remove(carta);
  }

  // Função que atualiza o índice do jogador atual
  void atualizarJogadorAtual() {
    jogadorAtualIndex = (jogadorAtualIndex + 1) % jogadores.length;
  }

  // Função que verifica se todos os jogadores jogaram uma carta
  bool todosJogadoresJogaramUmaCarta() {
    return cartasJogadasNaMesa.length == jogadores.length;
  }

  // Função que processa o fim da rodada
  void processarFimDaRodada() {
    jogadorVencedor = compararCartas(cartasJogadasNaMesa); // Determina o vencedor da rodada
    mostrarResultadoRodada(jogadorVencedor); // Mostra o resultado da rodada
    resultadosRodadas.add(ResultadoRodada(numeroRodada, jogadorVencedor)); // Adiciona o resultado da rodada à lista de resultados
    verificarVencedorDoJogo(resultadosRodadas); // Verifica se há um vencedor do jogo
  }

  // Função que mostra o resultado da rodada
  void mostrarResultadoRodada(Jogador? jogadorVencedor) {
    setState(() {
      resultadoRodada = jogadorVencedor != null
          ? 'O ${jogadorVencedor.nome} ganhou a rodada!'
          : 'Empate!';
      rodadacontinua = false;
      _showPopup(resultadoRodada); // Mostra um popup com o resultado da rodada
    });

    // Limpa as cartas jogadas na mesa após mostrar o resultado e reinicia a rodada
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        cartasJogadasNaMesa.clear();
        cartasJaJogadas.clear();
      });
    });
  }

  // Função que verifica se há um vencedor do jogo
  void verificarVencedorDoJogo(List<ResultadoRodada> resultadosRodadas) {
    Jogador? vencedorJogo = determinarVencedor(resultadosRodadas); // Determina o vencedor do jogo
    if (vencedorJogo != null) {
      rodadacontinua = false;

      vencedorJogo.pontuacao.adicionarPontuacaoTotal(); // Adiciona a pontuação ao vencedor

      for (var jogador in jogadores) {
        int pontuacaoTotal = vencedorJogo.pontuacao.getPontuacaoTotal(); // Obtém a pontuação total

        if (pontuacaoTotal >= 4) { // Verifica se a pontuação total é suficiente para ganhar o jogo
          resultadoRodada = '\nO Grupo ${jogador.nome} GANHOU o jogo!';
          _showPopup(resultadoRodada); // Mostra um popup com o resultado final
          break;
        }
      }

      if (jogoContinua) {
        Future.delayed(const Duration(seconds: 5), () {
          reiniciarRodada(); // Reinicia a rodada
        });
      }
    }
  }

  // Função que reinicia o jogo
  void reiniciarJogo() {
    setState(() {
      jogadores = Jogador.criarJogadores(['Jogador 1', 'Jogador 2'], 2); // Cria novos jogadores
      resultadosRodadas.clear(); // Limpa os resultados das rodadas
      jogadorVencedor = null;
      numeroRodada = 1;
      resultadoRodada = '';
      jogoContinua = true;
      rodadacontinua = true;
      reiniciarRodada(); // Reinicia a rodada
    });
  }

  // Função que mostra um popup com uma mensagem
  void _showPopup(String message) {
    _overlayEntry = _createOverlayEntry(message); // Cria um overlay com a mensagem
    Overlay.of(context).insert(_overlayEntry!); // Insere o overlay na tela
    Future.delayed(const Duration(seconds: 2), () {
      _overlayEntry?.remove(); // Remove o overlay após 2 segundos
      rodadacontinua = true;
    });
  }

  // Função que cria um overlay com uma mensagem
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
          jogarCarta(cartaSelecionada); // Joga a carta selecionada
        }
      },
      rodadacontinua: rodadacontinua, 
    );
  }
}
