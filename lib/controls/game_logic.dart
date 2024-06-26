import '../models/carta.dart';
import '../models/jogador.dart';
import 'package:tuple/tuple.dart';
import 'firebase_service.dart';
import 'resultado_rodada.dart';
import 'game.dart';
import 'truco_manager.dart';
import '../controls/score_manager.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../interface_user/popup_manager.dart';

class GameLogic {
  final FirebaseService firebaseService;
  final List<Jogador> jogadores;
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

  GameLogic(this.firebaseService, this.jogadores);

  void jogarCarta(Carta carta, BuildContext context) {
    final jogadorAtual = jogadores.firstWhere((jogador) => jogador.mao.contains(carta));
    adicionarCartaNaMesa(jogadorAtual, carta);
    removerCartaDaMao(jogadorAtual, carta);
    _syncMesaState(jogadorAtual.playerId);

    if (todosJogadoresJogaramUmaCarta()) {
      processarFimDaRodada(context);
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

  Future<void> _syncMesaState(int jogadorAtualIndex) async {
    print("_syncMesaState game logic");
    await firebaseService.syncMesaState(jogadorAtualIndex, cartasJogadasNaMesa);
  }

  bool todosJogadoresJogaramUmaCarta() {
    print("todosJogadoresJogaramUmaCarta");
    return cartasJogadasNaMesa.length == jogadores.length;
  }

  void processarFimDaRodada(BuildContext context) {
    print('processarFimDaRodada');
    jogadorVencedor = compararCartas(cartasJogadasNaMesa);
    resultadosRodadas.add(ResultadoRodada(numeroRodada, jogadorVencedor));
    verificarVencedorDoJogo(resultadosRodadas);
    _syncGameState();

    // Mostrar popup para ambos os jogadores e limpar a mesa
    Future.delayed(const Duration(seconds: 2), () {
      popupManager.mostrarPopup(context, resultadoRodada);
      limparMesa();
      _syncGameState(); // Sincroniza o estado do jogo após limpar a mesa
    });
  }

  void mostrarResultadoRodada(Jogador? jogadorVencedor, BuildContext context) {
    print('mostrarResultadoRodada');
    int result = jogadorVencedor == null ? 0 : (jogadorVencedor == jogadores[0] ? 1 : 2);
    roundResults.add(result);
    pontuacao.adicionarResultadoRodada(result);

    if (jogadorVencedor != null) {
      resultadoRodada = 'O ${jogadorVencedor.nome} ganhou a rodada!';
    } else {
      resultadoRodada = 'Empate!';
    }

    rodadacontinua = false;
    popupManager.mostrarPopup(context, resultadoRodada);
    rodadacontinua = true;

    Future.delayed(const Duration(seconds: 2), () {
      limparMesa();
      _syncGameState(); // Sincroniza o estado do jogo após limpar a mesa
    });
  }

  void limparMesa() {
    print('limparMesa');
    cartasJogadasNaMesa.clear();
    cartasJaJogadas.clear();
  }

  Future<void> _syncGameState() async {
    await firebaseService.syncGameState(
      jogadores.indexWhere((jogador) => jogador.mao.isNotEmpty),
      cartasJogadasNaMesa,
      cartasJaJogadas,
      resultadosRodadas,
      true,
      '',
      [],
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
