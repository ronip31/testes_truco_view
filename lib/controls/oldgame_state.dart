// import 'package:flutter/material.dart';
// import 'package:tuple/tuple.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import '../models/carta.dart';
// import '../models/jogador.dart';
// import '../models/baralho.dart';
// import 'resultado_rodada.dart';
// import 'game.dart';
// import '../interface_user/user_interface.dart';
// import 'pedir_truco.dart';
// import 'truco_manager.dart';
// import '../controls/score_manager.dart';
// import 'firebase_service.dart';

// class JogoTrucoScreen extends StatefulWidget {
//   final String roomId;
//   final String playerName;

//   const JogoTrucoScreen({Key? key, required this.roomId, required this.playerName}) : super(key: key);

//   @override
//   JogoTrucoScreenState createState() => JogoTrucoScreenState();
// }

// class JogoTrucoScreenState extends State<JogoTrucoScreen> {
//   List<Jogador> jogadores = [];
//   int jogadorAtualIndex = 0;
//   List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];
//   List<Carta> cartasJaJogadas = [];
//   List<ResultadoRodada> resultadosRodadas = [];
//   Jogador? jogadorVencedor;
//   int numeroRodada = 1;
//   String resultadoRodada = '';
//   bool jogoContinua = true;
//   bool rodadacontinua = true;
//   Carta? manilha;
//   OverlayEntry? _overlayEntry;
//   Truco truco = Truco();
//   final TrucoManager trucoManager = TrucoManager();
//   Pontuacao pontuacao = Pontuacao();
//   List<int> roundResults = [];
//   bool escondendoCarta = false;
//   bool gameReady = false;
//   late Jogador jogadorAtual;
//   late FirebaseService firebaseService;
//   bool gameStateLoaded = false; // Nova variável
//   StreamSubscription<DocumentSnapshot>? roomSubscription; // Novo: StreamSubscription para o listener

//   @override
//   void initState() {
//     super.initState();
//     firebaseService = FirebaseService(widget.roomId);
//     _initializeGame();
//   }

//   @override
//   void dispose() {
//     roomSubscription?.cancel(); // Cancelar o listener ao destruir o widget
//     super.dispose();
//   }

//   // Inicializa o jogo, configurando o listener para o documento da sala no Firestore
//   void _initializeGame() async {
//     final roomRef = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId);

//     roomSubscription = roomRef.snapshots().listen((snapshot) {
//       if (snapshot.exists && mounted) {
//         final data = snapshot.data() as Map<String, dynamic>;
//         final List<dynamic>? players = data['players'];
//         if (players != null && players.length == 2 && jogadores.isEmpty) {
//           jogadores = Jogador.criarJogadores(players.cast<String>(), 2);
//           jogadorAtual = jogadores.firstWhere((jogador) => jogador.nome == widget.playerName);
//           print('jogadorAtual: ${jogadorAtual.nome} com playerId: ${jogadorAtual.playerId}');
//           if (players[0] == widget.playerName && data['gameState'] == null) {
//             _distributeCards();
//           } else if (!gameStateLoaded) { // Verifica se o estado do jogo já foi carregado
//             _loadGameState(data['gameState']);
//           }
//           if (mounted) {
//             setState(() {});
//           }
//         } else if (data['gameState'] != null && !gameStateLoaded) { // Verifica se o estado do jogo já foi carregado
//           _loadGameState(data['gameState']);
//         }
//       }
//     });
//   }

//   // Distribui as cartas entre os jogadores e atualiza o estado no Firestore
//   void _distributeCards() async {
//     final baralho = Baralho();
//     baralho.embaralhar();
//     final todasMaosJogadores = baralho.distribuirCartasParaJogadores(2);

//     final cartasJogador1 = todasMaosJogadores[0].map((carta) => carta.toString()).toList();
//     final cartasJogador2 = todasMaosJogadores[1].map((carta) => carta.toString()).toList();

//     print('cartasJogador1 $cartasJogador1');
//     print('cartasJogador2 $cartasJogador2');
//     baralho.cartas[0].ehManilha = true;
//     final manilhaGlobal = baralho.cartas.firstWhere((carta) => carta.ehManilha).toString();

//     await firebaseService.distributeCards(cartasJogador1, cartasJogador2, manilhaGlobal).then((_) {
//       if (mounted) {
//         setState(() {
//           gameReady = true;
//         });
//       }
//     });
//   }

//   // Carrega o estado do jogo do Firestore
//   void _loadGameState(Map<String, dynamic>? gameState) {
//     if (gameState != null && mounted) {
//       setState(() {
//         manilha = Carta.fromString(gameState['manilha']);
//         if (jogadorAtual.nome == jogadores[0].nome) {
//           jogadorAtual.mao = (gameState['cartasJogador1'] as List).map((cartaMap) => Carta.fromString(cartaMap)).toList();
//           print('jogadorAtual.mao1 ${jogadorAtual.mao} e ${jogadorAtual.nome}');
//         } else if (jogadorAtual.nome == jogadores[1].nome) {
//           jogadorAtual.mao = (gameState['cartasJogador2'] as List).map((cartaMap) => Carta.fromString(cartaMap)).toList();
//           print('jogadorAtual.mao2 ${jogadorAtual.mao} e ${jogadorAtual.nome}');
//         }
//         gameReady = true;
//         gameStateLoaded = true; // Atualiza o indicador
//       });
//     }
//   }

//   // Sincroniza o estado da mesa no Firestore
//   Future<void> _syncMesaState() async {
//     if (!mounted) return;
//     await firebaseService.syncMesaState(jogadorAtualIndex, cartasJogadasNaMesa);
//   }

//   // Sincroniza o estado do jogo no Firestore
//   Future<void> _syncGameState() async {
//     if (!mounted) return;
//     await firebaseService.syncGameState(
//       jogadorAtualIndex,
//       cartasJogadasNaMesa,
//       cartasJaJogadas,
//       resultadosRodadas,
//       rodadacontinua,
//       resultadoRodada,
//       roundResults,
//     );
//   }

//   // Ações ao jogar uma carta
//   void jogarCarta(Carta carta) {
//     print('Jogador ${jogadorAtual.nome} (playerId: ${jogadorAtual.playerId}) está jogando a carta: ${carta.toString()}');
//     if (!rodadacontinua || !mounted) return;
//     setState(() {
//       if (escondendoCarta) {
//         carta.esconder();
//         escondendoCarta = false;
//       }
//       adicionarCartaNaMesa(carta);
//       removerCartaDaMao(carta);
//       atualizarJogadorAtual();

//       if (todosJogadoresJogaramUmaCarta()) {
//         rodadacontinua = false;
//         processarFimDaRodada();
//       }
//     });
//     _syncMesaState().then((_) {
//       print('Estado da mesa sincronizado com sucesso.');
//     }).catchError((error) {
//       print('Erro ao sincronizar o estado da mesa: $error');
//     });
//   }

//   // Adiciona a carta na mesa
//   void adicionarCartaNaMesa(Carta carta) {
//     if (!rodadacontinua) return;
//     print('Adicionando carta na mesa: ${carta.toString()}');
//     cartasJaJogadas.add(carta);
//     cartasJogadasNaMesa.add(Tuple2(
//       jogadores[jogadorAtualIndex],
//       {
//         'carta': carta,
//         'valor': carta.valorParaComparacao,
//       },
//     ));
//   }

//   // Remove a carta da mão do jogador
//   void removerCartaDaMao(Carta carta) {
//     print('Removendo carta da mão: ${carta.toString()}');
//     jogadores[jogadorAtualIndex].mao.remove(carta);
//   }

//   // Atualiza o índice do jogador atual
//   void atualizarJogadorAtual() {
//     jogadorAtualIndex = (jogadorAtualIndex + 1) % jogadores.length;
//     print('Próximo jogador é ${jogadores[jogadorAtualIndex].nome} (playerId: ${jogadores[jogadorAtualIndex].playerId})');
//   }

//   // Verifica se todos os jogadores jogaram uma carta
//   bool todosJogadoresJogaramUmaCarta() {
//     return cartasJogadasNaMesa.length == jogadores.length;
//   }

//   // Processa o fim da rodada
//   void processarFimDaRodada() {
//     jogadorVencedor = compararCartas(cartasJogadasNaMesa);
//     print('Fim da rodada. Vencedor: ${jogadorVencedor?.nome ?? 'Nenhum (empate)'}');
//     mostrarResultadoRodada(jogadorVencedor);
//     resultadosRodadas.add(ResultadoRodada(numeroRodada, jogadorVencedor));
//     verificarVencedorDoJogo(resultadosRodadas);
//   }

//   // Mostra o resultado da rodada
//   void mostrarResultadoRodada(Jogador? jogadorVencedor) {
//     setState(() {
//       int result = jogadorVencedor == null ? 0 : (jogadorVencedor == jogadores[0] ? 1 : 2);
//       roundResults.add(result);
//       pontuacao.adicionarResultadoRodada(result);

//       resultadoRodada = jogadorVencedor != null
//           ? 'O ${jogadorVencedor!.nome} ganhou a rodada!'
//           : 'Empate!';
//       rodadacontinua = false;
//       _showPopup(resultadoRodada);
//     });
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         cartasJogadasNaMesa.clear();
//         cartasJaJogadas.clear();
//       });
//     });
//     _syncGameState().then((_) {
//       print('Estado do jogo sincronizado com sucesso.');
//     }).catchError((error) {
//       print('Erro ao sincronizar o estado do jogo: $error');
//     });
//   }

//   // Verifica o vencedor do jogo
//   void verificarVencedorDoJogo(List<ResultadoRodada> resultadosRodadas) {
//     Jogador? vencedorJogo = determinarVencedor(resultadosRodadas);
//     if (vencedorJogo != null) {
//       rodadacontinua = false;

//       trucoManager.adicionarPontuacaoAoVencedor(vencedorJogo);

//       for (var jogador in jogadores) {
//         int pontuacaoTotal = vencedorJogo!.pontuacao.getPontuacaoTotal();

//         if (pontuacaoTotal >= 12) {
//           resultadoRodada = '\nO Grupo ${jogador.nome} GANHOU o jogo!';
//           _showPopup(resultadoRodada);
//           break;
//         }
//       }

//       if (jogoContinua) {
//         Future.delayed(const Duration(seconds: 5), () {
//           if (mounted) {
//             reiniciarRodada();
//           }
//         });
//       }
//     }
//   }

//   // Reinicia a rodada
//   void reiniciarRodada() {
//     setState(() {
//       resultadosRodadas.clear();
//       jogadorVencedor = null;
//       numeroRodada = 1;
//       resultadoRodada = '';
//       jogoContinua = true;
//       rodadacontinua = true;
//     });
//   }

//   // Exibe uma mensagem popup na tela
//   void _showPopup(String message) {
//     if (!mounted) return;
//     _overlayEntry = _createOverlayEntry(message);
//     Overlay.of(context).insert(_overlayEntry!);
//     Future.delayed(const Duration(seconds: 1), () {
//       if (_overlayEntry != null && mounted) {
//         _overlayEntry?.remove();
//       }
//       rodadacontinua = true;
//     });
//   }

//   OverlayEntry _createOverlayEntry(String message) {
//     return OverlayEntry(
//       builder: (context) => Positioned(
//         top: MediaQuery.of(context).size.height / 3,
//         left: MediaQuery.of(context).size.width / 4,
//         width: MediaQuery.of(context).size.width / 2,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.black87,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Center(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                   fontSize: 24,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Esconde a carta
//   void esconderCarta(Carta carta) {
//     if (!mounted) return;
//     setState(() {
//       carta.esconder();
//       adicionarCartaNaMesa(carta);
//       removerCartaDaMao(carta);
//       atualizarJogadorAtual();
//       if (todosJogadoresJogaramUmaCarta()) {
//         rodadacontinua = false;
//         processarFimDaRodada();
//       }
//     });
//     _syncGameState().then((_) {
//       print('Estado do jogo sincronizado com sucesso.');
//     }).catchError((error) {
//       print('Erro ao sincronizar o estado do jogo: $error');
//     });
//     _syncMesaState().then((_) {
//       print('Estado da mesa sincronizado com sucesso.');
//     }).catchError((error) {
//       print('Erro ao sincronizar o estado da mesa: $error');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!gameReady) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Aguardando o início do jogo...'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     final jogadorAtual = jogadores.firstWhere((jogador) => jogador.nome == widget.playerName);

//     return JogoTrucoLayout(
//       jogadorAtual: jogadorAtual,
//       resultadoRodada: resultadoRodada,
//       cartasJaJogadas: cartasJaJogadas,
//       manilha: manilha,
//       pontuacao: pontuacao,
//       onCartaSelecionada: (index) {
//         if (index >= 0 && index < jogadorAtual.mao.length) {
//           var cartaSelecionada = jogadorAtual.mao[index];
//           if (escondendoCarta) {
//             esconderCarta(cartaSelecionada);
//             escondendoCarta = false;
//           } else {
//             jogarCarta(cartaSelecionada);
//           }
//         }
//       },
//       rodadacontinua: rodadacontinua,
//       onEsconderPressed: () {
//         setState(() {
//           escondendoCarta = true;
//         });
//         _showEsconderMessage();
//       },
//     );
//   }

//   void _showEsconderMessage() {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Escolha uma carta para esconder ou clique em cancelar'),
//         action: SnackBarAction(
//           label: 'Cancelar',
//           onPressed: () {
//             if (mounted) {
//               setState(() {
//                 escondendoCarta = false;
//               });
//             }
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }
// }
