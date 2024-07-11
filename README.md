# truco_view20

Truco Royale é um jogo de truco online desenvolvido com Flutter e Firebase. O objetivo deste projeto é permitir que os jogadores possam jogar truco remotamente, sincronizando o estado do jogo em tempo real entre os dispositivos.

## Funcionalidades

- Jogo de Truco Online: Jogue truco com um amigo remotamente.
- Sincronização em Tempo Real: Utilize o Firebase para sincronizar o estado do jogo entre os jogadores.
- Interface Interativa: Interface de usuário amigável e intuitiva desenvolvida com Flutter.
- Gerenciamento de Salas: Crie ou entre em uma sala de jogo e aguarde seu oponente.
-Manilha Aleatória: As manilhas são embaralhadas e distribuídas automaticamente no início   de cada rodada.
- Popup de Resultado: Notificação do resultado da rodada


##Estrutura do Projeto
- main.dart: Ponto de entrada do aplicativo.
- interface_user/: Contém as telas e widgets de interface do usuário.
    - home_screen.dart: Tela inicial do jogo.
    - room_selection_screen.dart: Tela para seleção de salas.
- controls/: Contém a lógica do jogo e integração com Firebase.
    - game_logic.dart: Contém a lógica principal do jogo de truco.
    - firebase_service.dart: Integração com o Firebase para sincronização do estado do jogo.
    - turn_manager.dart: Gerencia a vez dos jogadores.
    - truco_manager.dart: Gerencia a lógica de truco.
    - game_screen.dart: Tela principal do jogo.
- models/: Contém as classes de modelo.
    - baralho.dart: Representação do baralho de cartas.
    - carta.dart: Representação de uma carta.
    - jogador.dart: Representação de um jogador.


## Observação
Jogo não está 100% funcional, após a primera rodada as cartas não aparecem nas mãos dos jogadores.

## Licença
Este projeto está licenciado sob a MIT License. Veja o arquivo LICENSE para mais detalhes.