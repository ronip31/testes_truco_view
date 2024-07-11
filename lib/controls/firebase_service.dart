import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import 'package:tuple/tuple.dart';
import 'resultado_rodada.dart';

class FirebaseService {
  final String roomId;

  // Construtor da classe, recebe o roomId da sala no Firebase
  FirebaseService(this.roomId);

  // Função para distribuir cartas para os jogadores e definir a manilha
  Future<void> distributeCards(List<String> cartasJogador1, List<String> cartasJogador2, String manilhaGlobal) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('distributeCards() called');
    print('Cartas Jogador 1: $cartasJogador1');
    print('Cartas Jogador 2: $cartasJogador2');
    print('Manilha Global: $manilhaGlobal');

    // Atualiza o estado do jogo no Firebase com as cartas distribuídas e a manilha
    await roomRef.update({
      'gameState': {
        'manilha': manilhaGlobal,
        'cartasJogador1': cartasJogador1,
        'cartasJogador2': cartasJogador2,
        'currentPlayerId': 1, // Define o primeiro jogador
        'nos': 0, // Inicializa a pontuação de 'Nós'
        'eles': 0, // Inicializa a pontuação de 'Eles'
      }
    });
  }

  // Função para sincronizar o estado da mesa (cartas jogadas) no Firebase
  Future<void> syncMesaState(int currentPlayerId, List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('Função syncMesaState chamada');
    print('Jogador Atual Id: $currentPlayerId');
    print('Cartas Jogadas na Mesa: ${cartasJogadasNaMesa.map((e) => {
      'jogador': e.item1.nome,
      'playerId': e.item1.playerId,
      'carta': e.item2['carta'].toString(),
      'valor': e.item2['valor']
    }).toList()}');

    // Atualiza o estado da mesa no Firebase com as cartas jogadas e o jogador atual
    await roomRef.update({
      'gameState': {
        'currentPlayerId': currentPlayerId,
        'cartasJogadasNaMesa': FieldValue.arrayUnion(cartasJogadasNaMesa.map((tuple) => {
          'jogador': tuple.item1.nome,
          'playerId': tuple.item1.playerId,
          'carta': tuple.item2['carta'].toString(),
          'valor': tuple.item2['valor'],
        }).toList())
      }
    });
  }

  // Função para sincronizar o estado completo do jogo no Firebase
  Future<void> syncGameState({
    required int currentPlayerId,
    required List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa,
    required List<Carta> cartasJaJogadas,
    required List<ResultadoRodada> resultadosRodadas,
    required bool rodadacontinua,
    required String resultadoRodada,
    required List<int> roundResults,
  }) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('syncGameState() called');
    print('Jogador Atual Id: $currentPlayerId');
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
    print('Resultado Rodada: $resultadosRodadas');
    print('Round Results: $roundResults');

    // Atualiza o estado completo do jogo no Firebase
    await roomRef.update({
      'gameState': {
        'currentPlayerId': currentPlayerId,
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

  // Função para carregar o estado atual do jogo do Firebase
  Future<Map<String, dynamic>?> loadGameState() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('loadGameState() called. Room Ref: $roomRef');
    final snapshot = await roomRef.get();
    return snapshot.data();
  }

  // Função para atualizar o resultado da rodada no Firebase
  Future<void> updateRoundResult(String resultadoRodada) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    await roomRef.update({
      'gameState': {
        'resultadoRodada': resultadoRodada,
        'rodadacontinua': false,
      }
    });
  }

  // Função para obter um stream do estado atual do jogo do Firebase
  Stream<DocumentSnapshot> getGameStateStream() {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    return roomRef.snapshots();
  }

  // Função para obter o ID do jogador atual do Firebase
  Future<int> getCurrentPlayerId() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final snapshot = await roomRef.get();
    final data = snapshot.data();
    return data?['gameState']['currentPlayerId'] ?? 1;
  }

  // Função para limpar o estado para a próxima rodada no Firebase
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

  // Função para atualizar a pontuação no Firebase
  Future<void> updateScore(int nos, int eles) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    await roomRef.update({
      'gameState': {
        'nos': nos,
        'eles': eles,
      }
    });
  }
}
