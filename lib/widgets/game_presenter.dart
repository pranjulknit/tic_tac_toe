import 'dart:async';

import '../models/ai.dart';
import '../models/utils.dart';

class GamePresenter {
  
 late void Function(int idx) showMoveOnUi;
  void Function(int winningPlayer) showGameEnd;

  late Ai _aiPlayer;

  GamePresenter(this.showMoveOnUi, this.showGameEnd) {
    _aiPlayer = Ai();
  }

  void onHumanPlayed(List<int> board) async {
    int evaluation = Utils.evaluateBoard(board);
    if (evaluation != Ai.NO_WINNERS_YET) {
      onGameEnd(evaluation);
      return;
    }

    int aiMove = await Future(() => _aiPlayer.play(board, Ai.AI_PLAYER));

    board[aiMove] = Ai.AI_PLAYER;

    evaluation = Utils.evaluateBoard(board);
    if (evaluation != Ai.NO_WINNERS_YET)
      onGameEnd(evaluation);
    else
      showMoveOnUi(aiMove);
  }

  void onGameEnd(int winner) {
    showGameEnd(winner);
  }
}
