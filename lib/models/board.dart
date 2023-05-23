import 'dart:math';

import 'field.dart';

class Board {
  final int lines;
  final int rows;
  int numBombs;

  final List<Field> _fields = [];

  Board({
    required this.lines,
    required this.rows,
    required this.numBombs,
  }) {
    _createFields();
    _connectNeighbors();
    _randomlyMines();
  }

  void restart() {
    for (var c in _fields) {
      c.restart();
    }
    _randomlyMines();
  }

  void revealBombs() {
    for (var c in _fields) {
      c.revealBombs();
    }
  }

  void _createFields() {
    for (int l = 0; l < lines; l++) {
      for (int c = 0; c < rows; c++) {
        _fields.add(Field(
          line: l,
          row: c,
        ));
      }
    }
  }

  void _connectNeighbors() {
    for (var field in _fields) {
      for (var neighbor in _fields) {
        field.addNeighbor(neighbor);
      }
    }
  }

  void _randomlyMines() {
    int randomly = 0;

    if (numBombs > lines * rows) {
      return;
    }

    while (randomly < numBombs) {
      int i = Random().nextInt(_fields.length);

      if (!_fields[i].mined) {
        randomly++;
        _fields[i].mine();
      }
    }
  }

  List<Field> get fields {
    return _fields;
  }

  bool get resolved {
    return _fields.every((c) => c.resolved);
  }
}
