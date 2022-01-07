import './ai.dart';

class Utils {
  static bool isBoardFull(List<int> board) {
    for (var val in board) {
      if (val == Ai.EMPTY_SPACE) return false;
    }

    return true;
  }

  static bool isMoveLegal(List<int> board, int move) {
    if (move < 0 || move >= board.length || board[move] != Ai.EMPTY_SPACE)
      return false;

    return true;
  }

  static int evaluateBoard(List<int> board) {
    for (var list in Ai.WIN_CONDITIONS_LIST) {
      if (board[list[0]] != Ai.EMPTY_SPACE &&
          board[list[0]] == board[list[1]] &&
          board[list[0]] == board[list[2]]) {
        return board[list[0]];
      }
    }

    if (isBoardFull(board)) {
      return Ai.DRAW;
    }

    return Ai.NO_WINNERS_YET;
  }

  static int flipPlayer(int currentPlayer) {
    return -1 * currentPlayer;
  }
}
