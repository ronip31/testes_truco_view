import 'package:flutter/material.dart';
import '../widgets/roundIndicator.dart';

class PontuacaoWidget extends StatelessWidget {
  final int nos;
  final int eles;
  final List<int> roundResults;

  const PontuacaoWidget({
    super.key,
    required this.nos,
    required this.eles,
    required this.roundResults,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreColumn('Nós', nos, 1),
              _buildScoreColumn('Eles', eles, 2),
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

  Widget _buildScoreColumn(String title, int score, int player) {
    print("Results for $title: $roundResults"); // Debug para verificar os resultados recebidos
    List<int> playerResults = roundResults.where((result) => result == player || result == 0).take(3).toList();
    List<Color> playerColors = playerResults.map((result) {
      return result == 0 ? Colors.yellow :
      result == player ? Colors.green : Colors.grey;
    }).toList();

    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(score.toString(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        RoundIndicator(colors: playerColors),
      ],
    );
  }
}
