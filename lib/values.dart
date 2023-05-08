import 'package:flutter/material.dart';

int rowLength = 10;
int colLength = 15;

enum Tetromino { L, J, I, O, S, Z, T }

enum Directions {
  // ignore: constant_identifier_names
  Left,
  //ignore: constant_identifier_names
  Right,
  // ignore: constant_identifier_names
  Down,
}

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Color(
      0xFFFFA500), // Orange Tetromino.JColor.fromARGB(255, 0, 102, 255), // Blue
  Tetromino.I: Color.fromARGB(255, 242, 0, 255), // Pink
  Tetromino.O: Color(0xFFFFFF00), // Yellow
  Tetromino.S: Color(0xFF008000), // Green
  Tetromino.Z: Color(0xFFFF0000), // Red
  Tetromino.T: Color.fromARGB(255, 144, 0, 255), // Purple
};
