import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool? win;
  final bool? toggle;
  final String? time;
  final int? numBombs;
  final Function()? onRestart;
  final Function()? onToggle;

  const ResultWidget({
    required this.win,
    required this.toggle,
    required this.time,
    required this.numBombs,
    required this.onRestart,
    required this.onToggle,
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
    return Container(
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              '$numBombs',
              style: const TextStyle(
                backgroundColor: Colors.black,
                color: Colors.red,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: FloatingActionButton(
                child: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              backgroundColor: _getColor(),
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  _getIcon(),
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: onRestart,
              ),
            ),
          ),
          SizedBox(
            height: size,
            width: size,
            child: InkWell(
              child: _getImage(),
              onTap: onToggle,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              time!,
              style: const TextStyle(
                backgroundColor: Colors.black,
                color: Colors.red,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
