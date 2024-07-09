import 'package:tuple/tuple.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import 'firebase_service.dart';
import 'resultado_rodada.dart';
import 'game.dart';
import 'truco_manager.dart';
import '../controls/score_manager.dart';
import 'dart:async';
import 'package:flutter/material.dart';
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

  GameLogic(this.firebaseService, this.jogadores)
      : turnManager = TurnManager();

  Jogador get jogadorAtual => jogadores.firstWhere((jogador) => jogador.playerId == turnManager.currentPlayerId);

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
      await _syncGameState();
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

  void removerCartaDaMao(Jogador jogador, Carta carta) {
    jogador.mao.remove(carta);
  }

  bool todosJogadoresJogaramUmaCarta() {
    print("todosJogadoresJogaramUmaCarta");
    return cartasJogadasNaMesa.length == jogadores.length;
  }

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

  void limparMesa() {
    print('limparMesa');
    cartasJogadasNaMesa.clear();
    cartasJaJogadas.clear();
    print('limparMesa as cartasJogadasNaMesa: $cartasJogadasNaMesa');
    print('limparMesa as cartasJaJogadas: $cartasJaJogadas');
  }

  Future<void> _syncGameState() async {
    await firebaseService.syncGameState(
      currentPlayerId: turnManager.currentPlayerId,
      cartasJogadasNaMesa: cartasJogadasNaMesa,
      cartasJaJogadas: cartasJaJogadas,
      resultadosRodadas: resultadosRodadas,
      rodadacontinua: true,
      roundResults: roundResults,
    );
  }

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
    print('reiniciarRodada() called');
    resultadosRodadas.clear();
    jogadorVencedor = null;
    numeroRodada = 1;
    resultadoRodada = '';
    jogoContinua = true;
    rodadacontinua = true;
  }
}
