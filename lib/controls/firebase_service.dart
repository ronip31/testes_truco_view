import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/carta.dart';
import '../models/jogador.dart';
import 'package:tuple/tuple.dart';
import 'resultado_rodada.dart';

class FirebaseService {
  final String roomId;

  FirebaseService(this.roomId);

  // Método para distribuir as cartas e atualizar o estado no Firestore
  Future<void> distributeCards(List<String> cartasJogador1, List<String> cartasJogador2, String manilhaGlobal) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);

    await roomRef.update({
      'gameState': {
        'manilha': manilhaGlobal,
        'cartasJogador1': cartasJogador1,
        'cartasJogador2': cartasJogador2,
      }
    });
  }

  // Método para sincronizar o estado da mesa no Firestore
  Future<void> syncMesaState(int jogadorAtualIndex, List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('Função syncMesaState ${jogadorAtualIndex} e cartasJogadasNaMesa: ${cartasJogadasNaMesa}');
    print('Função syncMesaState roomRef: ${roomRef} ');
    await roomRef.update({
      'mesaState': {
        'jogadorAtualIndex': jogadorAtualIndex,
        'cartasJogadasNaMesa': cartasJogadasNaMesa.map((e) => {
          'jogador': e.item1.nome,
          'carta': e.item2['carta'].toString(),
          'valor': e.item2['valor']
        }).toList(),
      }
    });
  }

  // Método para sincronizar o estado do jogo no Firestore
  Future<void> syncGameState(int jogadorAtualIndex, List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa, List<Carta> cartasJaJogadas, List<ResultadoRodada> resultadosRodadas, bool rodadacontinua, String resultadoRodada, List<int> roundResults) async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('Função syncGameState roomRef: ${roomRef} ');
    await roomRef.update({
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

  // Método para carregar o estado do jogo do Firestore
  Future<Map<String, dynamic>?> loadGameState() async {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    print('Função loadGameState roomRef: ${roomRef} ');
    final snapshot = await roomRef.get();
    return snapshot.data();
  }
}
