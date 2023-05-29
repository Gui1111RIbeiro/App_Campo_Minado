import 'package:flutter/material.dart';

import 'explosion_exception.dart';

class Field {
  final int line;
  final int row;
  final List<Field> neighbors = [];

  bool _opened = false;
  bool _marked = false;
  bool _mined = false;
  bool _explosion = false;

  Field({
    required this.line,
    required this.row,
  });

  void addNeighbor(Field vizinho) {
    final deltaLine = (line - vizinho.line).abs();
    final deltaRow = (row - vizinho.row).abs();

    if (deltaLine == 0 && deltaRow == 0) {
      return;
    }

    if (deltaLine <= 1 && deltaRow <= 1) {
      neighbors.add(vizinho);
    }
  }

  void open() {
    if (_opened) {
      return;
    }
    _opened = true;

    if (_mined) {
      _explosion = true;
      throw ExplosionException();
    }

    if (safeNeighborhood) {
      for (var v in neighbors) {
        v.open();
      }
    }
  }

  void openNeighborhood() {
    if (!_opened) {
      return;
    }
    if (numBombsInNeighborhood == neighbors.where((v) => v.marked).length) {
      for (var v in neighbors) {
        if (v.mined && !v._marked || !v.mined && v.marked) {
          _explosion = true;
          throw ExplosionException();
        }
        if (!v.mined && !v._opened) {
          v.open();
        }
      }
    }
  }

  void revealBombs() {
    if (_mined) {
      _opened = true;
    }
  }

  void mine() {
    _mined = true;
  }

  void toggle() {
    _marked = !_marked;
  }

  void restart() {
    _opened = false;
    _marked = false;
    _mined = false;
    _explosion = false;
  }

  bool get mined {
    return _mined;
  }

  bool get explosion {
    return _explosion;
  }

  bool get opened {
    return _opened;
  }

  bool get marked {
    return _marked;
  }

  bool get resolved {
    bool minadoEMarcado = mined && marked;
    bool seguroEAberto = !mined && opened;
    return minadoEMarcado || seguroEAberto;
  }

  bool get safeNeighborhood {
    return neighbors.every((v) => !v.mined);
  }

  int get numBombsInNeighborhood {
    return neighbors.where((v) => v.mined).length;
  }
}
