class TurnManager {
  int _currentPlayerId = 1;

  int get currentPlayerId => _currentPlayerId;

  void nextTurn(int totalPlayers) {
    _currentPlayerId = (_currentPlayerId % totalPlayers) + 1;
    print('_currentPlayerId: $_currentPlayerId');
  }

  void resetTurn() {
    _currentPlayerId = 1;
  }

  void setCurrentPlayerId(int playerId) {
    _currentPlayerId = playerId;
  }

  void updateCurrentPlayerIdFromFirebase(int playerId) {
    _currentPlayerId = playerId;
  }
}
