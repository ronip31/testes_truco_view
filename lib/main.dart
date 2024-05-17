import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'models/carta.dart';
import 'models/jogador.dart';
import 'widgets/mao_jogador_widget.dart';
import 'jogo.dart';
import '../models/baralho.dart';



void main() {
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo de Truco',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JogoTrucoScreen(),
    );
  }
}

class JogoTrucoScreen extends StatefulWidget {
  @override
  _JogoTrucoScreenState createState() => _JogoTrucoScreenState();
}

class _JogoTrucoScreenState extends State<JogoTrucoScreen> {
  List<Jogador> jogadores = [];
  int jogadorAtualIndex = 0;
  List<Carta> mesa = [];
  Jogo jogo = Jogo();
  List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];
  Set<Carta> cartasJaJogadas = {}; 
  Jogador? jogadorVencedor;

  @override
  void initState() {
    super.initState();
    iniciarJogo();
  }

  void iniciarJogo() {
    jogadores = Jogador.criarJogadores(['Jogador 1', 'Jogador 2'], 2);
    jogo.finalizarRodada(jogadores, Baralho(), 2);
    jogadores[0].obterCartaDaMao();
    jogadores[1].obterCartaDaMao();
  }

  void jogarCarta(index, cartasJogadasNaMesa) {
    setState(() {
      jogadores[jogadorAtualIndex].mao.remove(index);
      jogadorAtualIndex = (jogadorAtualIndex + 1) % jogadores.length;


      // Checa se todos os jogadores jogaram suas cartas
      if (jogadorAtualIndex == 0) {
        // Todos os jogadores jogaram, então compara as cartas
        jogadorVencedor = Jogo.compararCartas(cartasJogadasNaMesa);
        print('jogadorVencedor111: ${jogadorVencedor}');
        if (jogadorVencedor != null) {

          print('\n\rGrupo ${jogadorVencedor} ganhou a rodada!');
          // Limpa a lista de cartas jogadas na mesa após determinar o vencedor da rodada
          cartasJogadasNaMesa.clear();
        } else {
          print('\n\rEmpate! Ninguém ganhou a rodada .');
        }
      }
    });
  }

  // No método build da classe _JogoTrucoScreenState, passe o índice da carta selecionada para a função selecionarCarta
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Jogo de Truco'),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Jogador Atual: ${jogadores[jogadorAtualIndex].nome}',
          style: TextStyle(fontSize: 24.0),
        ),
        SizedBox(height: 20.0),
        MaoJogadorWidget(
          mao: jogadores[jogadorAtualIndex].mao,
          
          onCartaSelecionada: (index) {
            print(jogadores[jogadorAtualIndex].mao);
            setState(() {
              var infocarta = jogadores[jogadorAtualIndex].selecionarCarta(jogadores[jogadorAtualIndex], index );
              print('infocarta: ${infocarta}');
              var cartaSelecionada = infocarta?.item1;
              var valorCarta = infocarta?.item3;
              print('MAIN: cartaSelecionada: ${cartaSelecionada} e valorCarta: ${valorCarta}');

              
              
              var jogadorAtual = jogadores[jogadorAtualIndex];
              cartasJogadasNaMesa.add(Tuple2<Jogador, Map<String, dynamic>>(jogadorAtual, {
                'carta': cartaSelecionada,
                'valor': valorCarta,
                'jogadorQueAceitouTruco': null,
                'pontosTruco': 0,
              }));
              
              // Chama a função jogarCarta com a carta selecionada
              jogarCarta(index, cartasJogadasNaMesa);
            });
          },
        ),
      ],
    ),
  );
}

}