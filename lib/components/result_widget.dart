import 'package:flutter/material.dart';

import '../screens/settings.dart';

class ResultWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool? win;
  final bool? toggle;
  final String? time;
  final int? numBombs;
  final bool Function() getVibration;
  final bool Function() getSound;
  final String Function() getDifficulty;
  final Function()? onRestart;
  final Function()? onToggle;
  final Function(bool) onToggleVibration;
  final Function(bool) onToggleSound;
  final Function(String) onDifficultyChanged;

  const ResultWidget({
    required this.win,
    required this.toggle,
    required this.time,
    required this.numBombs,
    required this.getVibration,
    required this.getSound,
    required this.getDifficulty,
    required this.onRestart,
    required this.onToggle,
    required this.onToggleVibration,
    required this.onToggleSound,
    required this.onDifficultyChanged,
    Key? key,
  }) : super(key: key);

  Color _getColor() {
    if (win == null) {
      return Colors.yellow;
    } else if (win!) {
      return Colors.green[300]!;
    } else {
      return Colors.red[300]!;
    }
  }

  IconData _getIcon() {
    if (win == null) {
      return Icons.sentiment_satisfied;
    } else if (win!) {
      return Icons.sentiment_very_satisfied;
    } else {
      return Icons.sentiment_very_dissatisfied;
    }
  }

  Image _getImage() {
    if (!toggle!) {
      return Image.asset('assets/images/bomba_1.jpeg');
    } else {
      return Image.asset('assets/images/bandeira.jpeg');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * 0.07;
    final fontSize = size * 0.6;

    return Container(
      color: Colors.grey.shade400,
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          border: Border.all(
              color: Colors.white, width: 2.0, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Transform.scale(
                      scale: size / 60,
                      child: Text(
                        '$numBombs',
                        style: TextStyle(
                          backgroundColor: Colors.black,
                          color: Colors.red,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.grey.shade600,
                      iconSize: fontSize * 1.2,
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                              getVibration: getVibration,
                              getSound: getSound,
                              getDifficulty: getDifficulty,
                              onDifficultyChanged: onDifficultyChanged,
                              onToggleVibration: onToggleVibration,
                              onToggleSound: onToggleSound,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: _getColor(),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    _getIcon(),
                    color: Colors.black,
                    size: 40,
                  ),
                  onPressed: onRestart,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: size,
                    width: size,
                    child: InkWell(
                      onTap: onToggle,
                      child: _getImage(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Transform.scale(
                      scale: size / 60,
                      child: Text(
                        time!,
                        style: TextStyle(
                          backgroundColor: Colors.black,
                          color: Colors.red,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
