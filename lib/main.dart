import 'package:flutter/material.dart';

void main() {
  runApp(TrucoGame());
}

class TrucoGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truco Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TrucoGameScreen(),
    );
  }
}

class TrucoGameScreen extends StatefulWidget {
  @override
  _TrucoGameScreenState createState() => _TrucoGameScreenState();
}

class _TrucoGameScreenState extends State<TrucoGameScreen> {
  int nosScore = 0;
  int elesScore = 0;
  List<String> playerCards = ['K', '4', 'Q'];
  List<String> opponentCards = ['?', '?', '?'];

  void _increaseNosScore() {
    setState(() {
      nosScore++;
    });
  }

  void _increaseElesScore() {
    setState(() {
      elesScore++;
    });
  }

  void _handleTruco() {
    // Lógica do jogo para "Truco"
    print('Truco button pressed');
    // Adicione a lógica do jogo aqui
  }

  void _handleCorrer() {
    // Lógica do jogo para "Correr"
    print('Correr button pressed');
    // Adicione a lógica do jogo aqui
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              color: Colors.brown[700],
            ),
          ),
          // Table
          Center(
            child: Container(
              width: 300,
              height: 400,
              color: Colors.green[800],
            ),
          ),
          // Score Information
          Positioned(
            top: 55,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScoreInfo(groupName: 'Nós', score: nosScore),
                ScoreInfo(groupName: 'Eles', score: elesScore),
              ],
            ),
          ),
          // Player Cards
          Positioned(
            bottom: 75,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: playerCards
                  .map((card) => PlayerCard(rank: card, suit: 'hearts'))
                  .toList(),
            ),
          ),
          // Truco and Correr buttons
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TrucoButton(onPressed: _handleTruco),
                SizedBox(width: 20),
                CorrerButton(onPressed: _handleCorrer),
              ],
            ),
          ),
          // Top Opponent Cards
          Positioned(
            top: 175,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: opponentCards.map((_) => SmallOpponentCard()).toList(),
            ),
          ),
          // Left Opponent Cards
          Positioned(
            top: 100,
            left: 5,
            bottom: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: opponentCards.map((_) => SmallOpponentCard()).toList(),
              ),
            ),
          ),
          // Right Opponent Cards
          Positioned(
            top: 100,
            right: 5,
            bottom: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: opponentCards.map((_) => SmallOpponentCard()).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScoreInfo extends StatelessWidget {
  final String groupName;
  final int score;

  ScoreInfo({required this.groupName, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          groupName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class PlayerCard extends StatelessWidget {
  final String rank;
  final String suit;

  PlayerCard({required this.rank, required this.suit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 95,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4)
        ],
      ),
      child: Center(
        child: Text(
          '$rank\n$suit',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}

class TrucoButton extends StatelessWidget {
  final VoidCallback onPressed;

  TrucoButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('TRUCO'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 20),
      ),
    );
  }
}

class CorrerButton extends StatelessWidget {
  final VoidCallback onPressed;

  CorrerButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('CORRER'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 20),
      ),
    );
  }
}

class SmallOpponentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
      width: 40,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4)
        ],
      ),
    );
  }
}
