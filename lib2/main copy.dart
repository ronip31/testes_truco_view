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

class TrucoGameScreen extends StatelessWidget {
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
          // Player Cards
          Positioned(
            bottom: 75,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerCard('K', 'hearts'),
                PlayerCard('4', 'spades'),
                PlayerCard('Q', 'hearts'),
              ],
            ),
          ),
          // Truco and Correr buttons
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TrucoButton(),
                SizedBox(width: 20),
                CorrerButton(),
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
              children: [
                SmallOpponentCard(),
                SmallOpponentCard(),
                SmallOpponentCard(),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 5,
            bottom: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallOpponentCard(),
                  SmallOpponentCard(),
                  SmallOpponentCard(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 5,
            bottom: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallOpponentCard(),
                  SmallOpponentCard(),
                  SmallOpponentCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  final String rank;
  final String suit;

  PlayerCard(this.rank, this.suit);

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
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
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
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
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
