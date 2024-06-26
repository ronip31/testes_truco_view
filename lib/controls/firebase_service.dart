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
      }
    });
  }

  Future<void> syncMesaState(int jogadorAtualIndex, List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa) async {
  final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
  print('Função syncMesaState chamada');
  print('Jogador Atual Index: $jogadorAtualIndex');
  print('Cartas Jogadas na Mesa: ${cartasJogadasNaMesa.map((e) => {
    'jogador': e.item1.nome,
    'playerId': e.item1.playerId,
    'carta': e.item2['carta'].toString(),
    'valor': e.item2['valor']
  }).toList()}');
  
  await roomRef.update({
      'mesaState': {
        'jogadorAtualIndex': jogadorAtualIndex,
        'cartasJogadasNaMesa': cartasJogadasNaMesa.map((tuple) => {
          'jogador': tuple.item1.nome,
          'playerId': tuple.item1.playerId,
          'carta': tuple.item2['carta'].toString(),
          'valor': tuple.item2['valor'],
        }).toList(),
      }
  });
}

  Future<void> syncGameState(int jogadorAtualIndex, List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa, List<Carta> cartasJaJogadas, List<ResultadoRodada> resultadosRodadas, bool rodadacontinua, String resultadoRodada, List<int> roundResults) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('syncGameState() called');
    print('Jogador Atual Index: $jogadorAtualIndex');
    print('Cartas Jogadas na Mesa: ${cartasJogadasNaMesa.map((e) => {
          'jogador': e.item1.nome,
          'playerId': e.item1.playerId,
          'carta': e.item2['carta'].toString(),
          'valor': e.item2['valor']
        }).toList()}');
    print('Cartas Já Jogadas: ${cartasJaJogadas.map((carta) => carta.toString()).toList()}');
    print('Resultados Rodadas: ${resultadosRodadas.map((resultado) => {
          'numeroRodada': resultado.numeroRodada,
          'jogadorVencedor': resultado.jogadorVencedor?.nome
        }).toList()}');
    print('Rodada Continua: $rodadacontinua');
    print('Resultado Rodada: $resultadoRodada');
    print('Round Results: $roundResults');

    await roomRef.update({
      'gameState': {
        'jogadorAtualIndex': jogadorAtualIndex,
        'cartasJogadasNaMesa': cartasJogadasNaMesa.map((e) => {
          'jogador': e.item1.nome,
          'playerId': e.item1.playerId,
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

  Future<Map<String, dynamic>?> loadGameState() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('loadGameState() called. Room Ref: $roomRef');
    final snapshot = await roomRef.get();
    return snapshot.data();
  }

  Stream<DocumentSnapshot> getGameStateStream() {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('getGameStateStream() called. Room Ref: $roomRef');
    return roomRef.snapshots();
  }
}
