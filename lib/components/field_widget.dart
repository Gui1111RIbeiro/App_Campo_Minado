import 'package:flutter/material.dart';

import '../models/field.dart';

class FieldWidget extends StatelessWidget {
  final Field field;
  final void Function(Field) onOpen;

  const FieldWidget({
    required this.field,
    required this.onOpen,
    Key? key,
  }) : super(key: key);

  Widget _getImage() {
    int numBombs = field.numBombsInNeighborhood;
    if (field.opened && field.mined && field.explosion) {
      return Image.asset('assets/images/bomba_0.jpeg');
    } else if (field.opened && field.mined) {
      return Image.asset('assets/images/bomba_1.jpeg');
    } else if (field.opened) {
      return Image.asset('assets/images/aberto_$numBombs.jpeg');
    } else if (field.marked) {
      return Image.asset('assets/images/bandeira.jpeg');
    } else {
      return Image.asset('assets/images/fechado.jpeg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onOpen(field),
      child: _getImage(),
    );
  }
}
