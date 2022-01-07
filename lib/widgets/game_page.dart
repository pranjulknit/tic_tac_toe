// ignore_for_file: unnecessary_this, deprecated_member_use

import 'package:flutter/material.dart';
import '../models/ai.dart';
import './game_presenter.dart';
import './field.dart';


class GamePage extends StatefulWidget {
  final String title;

  GamePage(this.title);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  List<int> board = [];
  late int _currentPlayer;

  late GamePresenter _presenter;

  GamePageState() {
    _presenter = GamePresenter(_movePlayed, _onGameEnd);
  }

  void _onGameEnd(int winner) {
    var title = "Game over!";
    var content = "You lose :(";
    switch (winner) {
      case Ai.HUMAN: // will never happen :)
        title = "Congratulations!";
        content = "You managed to beat an unbeatable AI!";
        break;
      case Ai.AI_PLAYER:
        title = "Game Over!";
        content = "You lose :(";
        break;
      default:
        title = "Draw!";
        content = "No winners here.";
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                  color: Colors.cyan,
                  onPressed: () {
                    setState(() {
                      reinitialize();
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text(
                    "Restart",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  void _movePlayed(int idx) {
    setState(() {
      board[idx] = _currentPlayer;

      if (_currentPlayer == Ai.HUMAN) {
        _currentPlayer = Ai.AI_PLAYER;
        _presenter.onHumanPlayed(board);
      } else {
        _currentPlayer = Ai.HUMAN;
      }
    });
  }

  String getSymbolForIdx(int idx) {
    return Ai.SYMBOLS[board[idx]] as String;
  }

  @override
  void initState() {
    super.initState();
    reinitialize();
  }

  void reinitialize() {
    _currentPlayer = Ai.HUMAN;
    board = List.generate(9, (idx) => 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline))
        ],
      ),
      backgroundColor: const Color.fromRGBO(255, 254, 229, 1),
      body: Center(
        child: Container(
          width: 300,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(60),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 60,
                  width: double.infinity,
                  child: const Card(
                    borderOnForeground: true,
                    elevation: 2,
                    child: Text(
                      "\t\tYou are X ",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(9, (idx) {
                    return Card(
                      elevation: 10,
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Field(
                            idx: idx,
                            onTap: _movePlayed,
                            playerSymbol: getSymbolForIdx(idx)),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
