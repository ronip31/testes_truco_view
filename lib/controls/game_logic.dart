import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import 'firebase_service.dart';
import 'resultado_rodada.dart';
import 'game.dart';
import 'truco_manager.dart';
import 'score_manager.dart';
import 'dart:async';
import '../interface_user/popup_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'turn_manager.dart';

class GameLogic extends ChangeNotifier {
  final FirebaseService firebaseService;
  final List<Jogador> jogadores;
  final TurnManager turnManager;
  List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];
  List<Carta> cartasJaJogadas = [];
  List<ResultadoRodada> resultadosRodadas = [];
  Carta? manilha;
  bool rodadacontinua = true;
  final TrucoManager trucoManager = TrucoManager();
  String resultadoRodada = '';
  bool jogoContinua = true;
  Jogador? jogadorVencedor;
  int numeroRodada = 1;
  List<int> roundResults = [];
  Pontuacao pontuacao = Pontuacao();
  PopupManager popupManager = PopupManager();
  VoidCallback? onReiniciarRodada;

  // Construtor da classe
  GameLogic(this.firebaseService, this.jogadores) : turnManager = TurnManager();

  // Obtém o jogador atual
  Jogador get jogadorAtual => jogadores.firstWhere((jogador) => jogador.playerId == turnManager.currentPlayerId);

  // Função para jogar uma carta
  Future<void> jogarCarta(Carta carta, BuildContext context) async {
    final currentPlayerIdFromFirebase = await firebaseService.getCurrentPlayerId();
    turnManager.setCurrentPlayerId(currentPlayerIdFromFirebase);

    final jogadorAtual = this.jogadorAtual;
    print('void jogarCarta jogadorAtual ${jogadorAtual.nome}');
    print('void jogarCarta playerId ${jogadorAtual.playerId}');
    print('void jogarCarta turnManager.currentPlayerId ${turnManager.currentPlayerId}');

    // Verifica se o jogador atual tem a carta na mão e se é a vez dele
    if (jogadorAtual.mao.contains(carta) && jogadorAtual.playerId == turnManager.currentPlayerId) {
      adicionarCartaNaMesa(jogadorAtual, carta);
      removerCartaDaMao(jogadorAtual, carta);

      // Passa a vez para o próximo jogador
      turnManager.nextTurn(jogadores.length);
      await _syncMesaState(turnManager.currentPlayerId);
      print('jogadorAtualId ${turnManager.currentPlayerId}');
      print('void jogadorAtualId jogadorAtual ${jogadorAtual.nome}');

      if (todosJogadoresJogaramUmaCarta()) {
        processarFimDaRodada(context);
      } else {
        await _syncGameState(); // Sincroniza o estado do jogo após a mudança de turno
      }
    } else {
      print('Não é a vez do jogador ou a carta não está na mão dele.');
    }
  }

  // Adiciona uma carta na mesa
  void adicionarCartaNaMesa(Jogador jogador, Carta carta) {
    print('adicionarCartaNaMesa do game logic');
    cartasJaJogadas.add(carta);
    cartasJogadasNaMesa.add(Tuple2(
      jogador,
      {
        'carta': carta,
        'valor': carta.valorParaComparacao,
      },
    ));
  }

  // Remove uma carta da mão do jogador
  void removerCartaDaMao(Jogador jogador, Carta carta) {
    jogador.mao.remove(carta);
  }

  // Sincroniza o estado da mesa com o Firebase
  Future<void> _syncMesaState(int currentPlayerId) async {
    print("_syncMesaState game logic");
    await firebaseService.syncMesaState(currentPlayerId, cartasJogadasNaMesa);
  }

  // Verifica se todos os jogadores jogaram uma carta
  bool todosJogadoresJogaramUmaCarta() {
    print("todosJogadoresJogaramUmaCarta");
    return cartasJogadasNaMesa.length == jogadores.length;
  }

  // Processa o fim da rodada
  void processarFimDaRodada(BuildContext context) {
    print('processarFimDaRodada');
    jogadorVencedor = compararCartas(cartasJogadasNaMesa);
    mostrarResultadoRodada(jogadorVencedor, context);
    resultadosRodadas.add(ResultadoRodada(numeroRodada, jogadorVencedor));
    verificarVencedorDoJogo(resultadosRodadas);
    _syncGameState();

    // Mostrar popup para ambos os jogadores e limpar a mesa
    Future.delayed(const Duration(seconds: 2), () {
      limparMesa();
      turnManager.resetTurn(); // Reinicia o índice do jogador para a próxima rodada
      _syncGameState(); // Sincroniza o estado do jogo após limpar a mesa
      notifyListeners(); // Notifica os ouvintes (incluindo o widget) sobre a mudança de estado
    });
  }

  // Mostra o resultado da rodada
  void mostrarResultadoRodada(Jogador? jogadorVencedor, BuildContext context) {
    int result = jogadorVencedor == null ? 0 : (jogadorVencedor == jogadores[0] ? 1 : 2);
    print('result $result');

    roundResults.add(result);
    pontuacao.adicionarResultadoRodada(result);
    print('Results updated: $roundResults');

    resultadoRodada = jogadorVencedor != null
        ? 'O ${jogadorVencedor.nome} ganhou a rodada!'
        : 'Empate!';
    rodadacontinua = false;

    firebaseService.updateRoundResult(resultadoRodada);

    StreamBuilder<DocumentSnapshot>(
      stream: firebaseService.getGameStateStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data != null) {
            var gameState = data['gameState'] as Map<String, dynamic>?;
            var resultadoRodada = gameState?['resultadoRodada'];
            var rodadacontinua = gameState?['rodadacontinua'] ?? true;

            if (resultadoRodada != null && rodadacontinua == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                popupManager.mostrarPopup(context, resultadoRodada);
                // Chame o método para limpar o estado e iniciar a próxima rodada após 2 segundos
                Future.delayed(Duration(seconds: 2), () {
                  firebaseService.limparEstadoParaProximaRodada();
                  limparMesa();
                  _syncGameState(); // Sincroniza o estado do jogo após limpar a mesa
                  notifyListeners(); // Notifica os ouvintes (incluindo o widget) sobre a mudança de estado
                });
              });
            }
          }
        }
        return Container(); // Ou a interface do jogo
      },
    );
  }

  // Limpa as cartas da mesa
  void limparMesa() {
    print('limparMesa');
    cartasJogadasNaMesa.clear();
    cartasJaJogadas.clear();
    print('limparMesa as cartasJogadasNaMesa: $cartasJogadasNaMesa');
    print('limparMesa as cartasJaJogadas: $cartasJaJogadas');
  }

  // Sincroniza o estado do jogo com o Firebase
  Future<void> _syncGameState() async {
    print('_syncGameState: $cartasJogadasNaMesa $cartasJaJogadas');
    await firebaseService.syncGameState(
      currentPlayerId: turnManager.currentPlayerId,
      cartasJogadasNaMesa: cartasJogadasNaMesa,
      cartasJaJogadas: cartasJaJogadas,
      resultadosRodadas: resultadosRodadas,
      rodadacontinua: true,
      roundResults: roundResults,
      resultadoRodada: resultadoRodada,
    );
  }

  // Verifica o vencedor do jogo
void verificarVencedorDoJogo(List<ResultadoRodada> resultadosRodadas) {
  print('verificarVencedorDoJogo');
  Jogador? vencedorJogo = determinarVencedor(resultadosRodadas);
  if (vencedorJogo != null) {
    rodadacontinua = false;

    trucoManager.adicionarPontuacaoAoVencedor(vencedorJogo);

    for (var jogador in jogadores) {
      
      int pontuacaoTotal = vencedorJogo.pontuacao.getPontuacaoTotal();

      if (pontuacaoTotal >= 12) {
        resultadoRodada = '\nO Grupo ${jogador.nome} GANHOU o jogo!';
        // Adicionar lógica para mostrar a mensagem para todos os jogadores
        jogoContinua = false;
        break;
      }
    }

    // Atualiza a pontuação no Firebase
    firebaseService.updateScore(jogadores[0].pontuacao.getPontuacaoTotal(), jogadores[1].pontuacao.getPontuacaoTotal());

    if (jogoContinua) {
      Future.delayed(const Duration(seconds: 5), () {
        reiniciarRodada();
      });
    }
  }
}

  // Reinicia a rodada
  void reiniciarRodada() {
    print('reiniciarRodada() called');
    resultadosRodadas.clear();
    jogadorVencedor = null;
    numeroRodada = 1;
    resultadoRodada = '';
    jogoContinua = true;
    rodadacontinua = true;
    notifyListeners(); // Notifica os ouvintes (incluindo o widget) sobre a mudança de estado
    if (onReiniciarRodada != null) {
      onReiniciarRodada!();
    }
  }
}
