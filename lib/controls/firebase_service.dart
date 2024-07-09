import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import 'package:tuple/tuple.dart';
import 'resultado_rodada.dart';

class FirebaseService {
  final String roomId;

  FirebaseService(this.roomId);

  Future<void> distributeCards(List<String> cartasJogador1, List<String> cartasJogador2, String manilhaGlobal) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('distributeCards() called');
    print('Cartas Jogador 1: $cartasJogador1');
    print('Cartas Jogador 2: $cartasJogador2');
    print('Manilha Global: $manilhaGlobal');

    await roomRef.update({
      'gameState': {
        'manilha': manilhaGlobal,
        'cartasJogador1': cartasJogador1,
        'cartasJogador2': cartasJogador2,
        'currentPlayerId': 1, // Define o primeiro jogador
      }
    });
  }

  Future<void> syncGameState({
    int? currentPlayerId,
    List<Tuple2<Jogador, Map<String, dynamic>>>? cartasJogadasNaMesa,
    List<Carta>? cartasJaJogadas,
    List<ResultadoRodada>? resultadosRodadas,
    bool? rodadacontinua,
    String? resultadoRodada,
    List<int>? roundResults,
  }) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('syncGameState() called');

    final Map<String, dynamic> gameStateUpdate = {};

    if (currentPlayerId != null) {
      gameStateUpdate['currentPlayerId'] = currentPlayerId;
      print('Jogador Atual Id: $currentPlayerId');
    }

    if (cartasJogadasNaMesa != null) {
      gameStateUpdate['cartasJogadasNaMesa'] = cartasJogadasNaMesa.map((e) => {
        'jogador': e.item1.nome,
        'playerId': e.item1.playerId,
        'carta': e.item2['carta'].toString(),
        'valor': e.item2['valor']
      }).toList();
      print('Cartas Jogadas na Mesa: ${gameStateUpdate['cartasJogadasNaMesa']}');
    }

    if (cartasJaJogadas != null) {
      gameStateUpdate['cartasJaJogadas'] = cartasJaJogadas.map((carta) => carta.toString()).toList();
      print('Cartas Já Jogadas: ${gameStateUpdate['cartasJaJogadas']}');
    }

    if (resultadosRodadas != null) {
      gameStateUpdate['resultadosRodadas'] = resultadosRodadas.map((resultado) => {
        'numeroRodada': resultado.numeroRodada,
        'jogadorVencedor': resultado.jogadorVencedor?.nome
      }).toList();
      print('Resultados Rodadas: ${gameStateUpdate['resultadosRodadas']}');
    }

    if (rodadacontinua != null) {
      gameStateUpdate['rodadacontinua'] = rodadacontinua;
      print('Rodada Continua: $rodadacontinua');
    }

    if (resultadoRodada != null) {
      gameStateUpdate['resultadoRodada'] = resultadoRodada;
      print('Resultado Rodada: $resultadoRodada');
    }

    if (roundResults != null) {
      gameStateUpdate['roundResults'] = roundResults;
      print('Round Results: $roundResults');
    }

    await roomRef.update({'gameState': gameStateUpdate});
  }

  Future<Map<String, dynamic>?> loadGameState() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('loadGameState() called. Room Ref: $roomRef');
    final snapshot = await roomRef.get();
    return snapshot.data();
  }

  Future<void> updateRoundResult(String resultadoRodada) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    await roomRef.update({
      'gameState': {
        'resultadoRodada': resultadoRodada,
        'rodadacontinua': false,
      }
    });
  }

  Stream<DocumentSnapshot> getGameStateStream() {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    return roomRef.snapshots();
  }

  Future<int> getCurrentPlayerId() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final snapshot = await roomRef.get();
    final data = snapshot.data();
    return data?['gameState']['currentPlayerId'] ?? 1;
  }

  Future<void> limparEstadoParaProximaRodada() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    await roomRef.update({
      'gameState': {
        'rodadacontinua': true,
        'cartasJogadasNaMesa': [],
        'currentPlayerId': 1, // Reinicia a rodada com o primeiro jogador
      }
    });
  }
}
