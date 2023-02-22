import 'package:flutter/material.dart';
import 'dart:async';

import '../models/explosion_exception.dart';
import '../models/board.dart';
import '../models/field.dart';
import '../components/result_widget.dart';
import '../components/board_widget.dart';

class Minefield extends StatefulWidget {
  const Minefield({Key? key}) : super(key: key);

  @override
  State<Minefield> createState() => _MinefieldState();
}

class _MinefieldState extends State<Minefield> {
  bool _start = false;
  bool _toggle = false;
  bool? _win;
  Board? _board;
  DateTime _startTime = DateTime(0);
  DateTime _time = DateTime(0);
  static const int _startBombs = 48;
  int _bombs = _startBombs;

  void _restart() {
    setState(() {
      _start = false;
      _toggle = false;
      _win = null;
      _board!.restart();
      _bombs = _startBombs;
      _startTime = DateTime(0);
      _time = DateTime(0);
    });
  }

  void _open(Field campo) {
    if (_win != null) {
      return;
    }
    if (!_start) {
      _start = true;
      _startTime = DateTime.now();
    }

    setState(() {
      if (!_toggle || campo.opened) {
        try {
          if (campo.opened) {
            campo.openNeighborhood();
          } else {
            campo.open();
          }
          if (_board!.resolved) {
            _win = true;
          }
        } on ExplosionException {
          _win = false;
          _board!.revealBombs();
        }
      } else {
        if (_bombs == 0 && !campo.marked) {
          return;
        }
        campo.toggle();
        if (_board!.resolved) {
          _win = true;
        }
        if (campo.marked) {
          _bombs--;
        } else {
          _bombs++;
        }
      }
    });
  }

  void onToggle() {
    setState(() {
      _toggle = !_toggle;
    });
  }

  Board _getBoard(double width, double height) {
    if (_board == null) {
      int numRows = 15;
      double fieldSize = width / numRows;
      int numLines = (height / fieldSize).floor();

      _board = Board(
        lines: numLines,
        rows: numRows,
        numBombs: _bombs,
      );
    }
    return _board!;
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (_win == null && _start) {
          _time = DateTime.now();
        }
      });
    });
    return MaterialApp(
      home: Scaffold(
        appBar: ResultWidget(
          win: _win,
          toggle: _toggle,
          time:
              '${_time.difference(_startTime).inMinutes}:${_time.difference(_startTime).inSeconds % 60}',
          numBombs: _bombs,
          onRestart: _restart,
          onToggle: onToggle,
        ),
        body: Container(
          color: Colors.grey,
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              return BoardWidget(
                board: _getBoard(
                  constraints.maxWidth,
                  constraints.maxHeight,
                ),
                onOpen: _open,
              );
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
