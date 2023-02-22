import 'package:flutter/material.dart';

import '../models/field.dart';
import '../models/board.dart';
import 'field_widget.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final void Function(Field) onOpen;

  const BoardWidget({
    required this.board,
    required this.onOpen,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.count(
        crossAxisCount: board.rows,
        children: board.fields.map((c) {
          return FieldWidget(
            field: c,
            onOpen: onOpen,
          );
        }).toList(),
      ),
    );
  }
}
