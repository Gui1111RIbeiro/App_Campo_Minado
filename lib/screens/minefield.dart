import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../models/explosion_exception.dart';
import '../models/board.dart';
import '../models/field.dart';
import '../components/result_widget.dart';
import '../components/board_widget.dart';
import '../widgets/app_state.dart';

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
  int _startBombs = 48;
  int _bombs = 48;
  bool _vibrationEnabled = true;
  bool _soundEnabled = true;
  String _difficulty = 'Médio';
  String _formattedTime = '00:00';

  Timer? _timer;
  Duration _elapsedTime = Duration.zero;

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  late AppState appState;

  void _onDifficultyChanged(String value) {
    setState(() {
      if (value == 'Fácil') {
        _startBombs = 28;
      } else if (value == 'Médio') {
        _startBombs = 48;
      } else if (value == 'Difícil') {
        _startBombs = 68;
      }
      _difficulty = value;
      _restart();
    });
  }

  void _vibrate() {
    Vibration.vibrate(duration: 500);
  }

  void _toggleVibration(bool value) {
    setState(() {
      _vibrationEnabled = value;
    });

    if (value) {
      _vibrate();
    } else {
      Vibration.cancel();
    }
  }

  void _toggleSound(bool value) {
    setState(() {
      _soundEnabled = value;
    });
    if (value) {
      audioPlayer.play();
    } else {
      audioPlayer.stop();
    }
    appState.updateSoundState(value);
  }

  void _restart() {
    setState(() {
      _start = false;
      _toggle = false;
      _win = null;
      _bombs = _startBombs;
      _startTime = DateTime(0);
      _elapsedTime = Duration.zero;
      _formattedTime = '00:00';
      _board!.numBombs = _bombs;
      _board!.restart();
    });

    if (_vibrationEnabled) {
      _vibrate();
    }
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
            _vibrate();
          } else {
            campo.open();
          }
          if (_board!.resolved) {
            _win = true;
          }
        } on ExplosionException {
          _win = false;
          _board!.revealBombs();
          _vibrate();
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

  void _onToggle() {
    setState(() {
      _toggle = !_toggle;
    });
  }

  bool _getSound() {
    return _soundEnabled;
  }

  bool _getVibration() {
    return _vibrationEnabled;
  }

  String _getDifficult() {
    return _difficulty;
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
  void initState() {
    super.initState();
    appState = AppState(getSound: _getSound);
    appState.initialize();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (_win == null && _start) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_startTime);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _formattedTime =
        '${_elapsedTime.inMinutes.toString().padLeft(2, '0')}:${(_elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}';
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: ResultWidget(
            win: _win,
            toggle: _toggle,
            time: _formattedTime,
            numBombs: _bombs,
            getVibration: _getVibration,
            getSound: _getSound,
            getDifficulty: _getDifficult,
            onRestart: _restart,
            onToggle: _onToggle,
            onToggleVibration: _toggleVibration,
            onToggleSound: _toggleSound,
            onDifficultyChanged: _onDifficultyChanged,
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
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
