import 'utils.dart';

class Ai {
  static const int HUMAN = 1;
  static const int AI_PLAYER = -1;
  static const int NO_WINNERS_YET = 0;
  static const int DRAW = 2;

  static const int EMPTY_SPACE = 0;
  static const SYMBOLS = {EMPTY_SPACE: "", HUMAN: "X", AI_PLAYER: "O"};

  static const int WIN_SCORE = 100;
  static const int DRAW_SCORE = 0;
  static const int LOSE_SCORE = -100;

  static const WIN_CONDITIONS_LIST = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  int play(List<int> board, int currentPlayer) {
    return _getBestMove(board, currentPlayer).move;
  }

  int _getBestScore(List<int> board, int currentPlayer) {
    int evaluation = Utils.evaluateBoard(board);

    if (evaluation == currentPlayer) return WIN_SCORE;

    if (evaluation == DRAW) return DRAW_SCORE;

    if (evaluation == Utils.flipPlayer(currentPlayer)) {
      return LOSE_SCORE;
    }

    return _getBestMove(board, currentPlayer).score;
  }

  Move _getBestMove(List<int> board, int currentPlayer) {
    List<int> newBoard;
    Move bestMove = Move(score: -10000, move: -1);

    for (int currentMove = 0; currentMove < board.length; currentMove++) {
      if (!Utils.isMoveLegal(board, currentMove)) continue;

      newBoard = List.from(board);
      newBoard[currentMove] = currentPlayer;
      int nextScore = -_getBestScore(newBoard, Utils.flipPlayer(currentPlayer));

      if (nextScore > bestMove.score) {
        bestMove.score = nextScore;
        bestMove.move = currentMove;
      }
    }

    return bestMove;
  }
}

class Move {
  int score;
  int move;

  Move({required this.score, required this.move});
}
