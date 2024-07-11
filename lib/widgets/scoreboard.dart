import 'package:flutter/material.dart';
import '../widgets/roundIndicator.dart';
import '../controls/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PontuacaoWidget extends StatelessWidget {
  final String roomId; // Adiciona roomId para buscar dados do Firebase
  final int nos;
  final int eles;
  final List<int> roundResults;

  const PontuacaoWidget({
    super.key,
    required this.roomId, // Adiciona roomId no construtor
    required this.nos,
    required this.eles,
    required this.roundResults,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseService(roomId).getGameStateStream(), // Obtém o stream do estado do jogo do Firebase
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data != null && data['gameState'] != null) {
            var gameState = data['gameState'];
            var roundResults = gameState['roundResults'] as List<dynamic>? ?? [];
            var nos = gameState['nos'] ?? 0;
            var eles = gameState['eles'] ?? 0;

            return _buildScoreContainer(nos, eles, roundResults.cast<int>());
          }
        }
        return _buildScoreContainer(nos, eles, roundResults);
      },
    );
  }

  Widget _buildScoreContainer(int nos, int eles, List<int> roundResults) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreColumn('Nós', nos, 1, roundResults),
              _buildScoreColumn('Eles', eles, 2, roundResults),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.4),
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildScoreColumn(String title, int score, int player, List<int> roundResults) {
    print("Results for $title: $roundResults"); // Debug para verificar os resultados recebidos
    List<int> playerResults = roundResults.take(3).toList();
    List<Color> playerColors = playerResults.asMap().entries.map((entry) {
      int result = entry.value;
      if (result == 0) return Colors.yellow; // Empate
      if (result == player) return Colors.green; // Vitória para o jogador especificado
      return Colors.grey; // Outro resultado ou nenhum resultado ainda
    }).toList();

    // Adiciona cores cinzas se houver menos de 3 rodadas jogadas
    while (playerColors.length < 3) {
      playerColors.add(Colors.grey);
    }

    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(score.toString(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('Rodadas', style: TextStyle(fontSize: 15)),
        RoundIndicator(colors: playerColors),
      ],
    );
  }
}
