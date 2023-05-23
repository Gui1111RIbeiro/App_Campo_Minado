import 'package:flutter/material.dart';

Widget buildNumberWidget(int value, double fontSize) {
  final List<List<List<int>>> segments = [
    // Segmentos para o número 0
    [
      [1, 1, 1],
      [1, 0, 1],
      [1, 0, 1],
      [1, 0, 1],
      [1, 1, 1],
    ],
    // Segmentos para o número 1
    [
      [0, 0, 1],
      [0, 0, 1],
      [0, 0, 1],
      [0, 0, 1],
      [0, 0, 1],
    ],
    // Segmentos para o número 2
    [
      [1, 1, 1],
      [0, 0, 1],
      [1, 1, 1],
      [1, 0, 0],
      [1, 1, 1],
    ],
    // Segmentos para o número 3
    [
      [1, 1, 1],
      [0, 0, 1],
      [1, 1, 1],
      [0, 0, 1],
      [1, 1, 1],
    ],
    // Segmentos para o número 4
    [
      [1, 0, 1],
      [1, 0, 1],
      [1, 1, 1],
      [0, 0, 1],
      [0, 0, 1],
    ],
    // Segmentos para o número 5
    [
      [1, 1, 1],
      [1, 0, 0],
      [1, 1, 1],
      [0, 0, 1],
      [1, 1, 1],
    ],
    // Segmentos para o número 6
    [
      [1, 1, 1],
      [1, 0, 0],
      [1, 1, 1],
      [1, 0, 1],
      [1, 1, 1],
    ],
    // Segmentos para o número 7
    [
      [1, 1, 1],
      [0, 0, 1],
      [0, 0, 1],
      [0, 0, 1],
      [0, 0, 1],
    ],
    // Segmentos para o número 8
    [
      [1, 1, 1],
      [1, 0, 1],
      [1, 1, 1],
      [1, 0, 1],
      [1, 1, 1],
    ],
    // Segmentos para o número 9
    [
      [1, 1, 1],
      [1, 0, 1],
      [1, 1, 1],
      [0, 0, 1],
      [0, 0, 1],
    ],
  ];

  List<List<int>> getSegmentsForDigit(int digit) {
    return segments[digit];
  }

  List<int> getDigits(int number) {
    final digits = <int>[];
    if (number == 0) {
      digits.add(0);
    } else {
      while (number != 0) {
        digits.insert(0, number % 10);
        number ~/= 10;
      }
    }
    return digits;
  }

  List<List<int>> getCombinedSegments(int number) {
    final digits = getDigits(number);
    final combinedSegments = <List<int>>[];
    for (final digit in digits) {
      final digitSegments = getSegmentsForDigit(digit);
      if (combinedSegments.isEmpty) {
        combinedSegments.addAll(digitSegments);
      } else {
        for (var i = 0; i < digitSegments.length; i++) {
          combinedSegments[i].addAll([0, ...digitSegments[i]]);
        }
      }
    }
    return combinedSegments;
  }

  final List<List<int>> combinedSegments = getCombinedSegments(value);

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: combinedSegments.map((segment) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: segment.map((isActive) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.all(1),
              color: isActive == 1 ? Colors.red[900] : Colors.transparent,
              height: fontSize,
            ),
          );
        }).toList(),
      );
    }).toList(),
  );
}
