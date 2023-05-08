import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetrisgame/piece.dart';
import 'package:tetrisgame/pixel.dart';
import 'package:tetrisgame/values.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameBoard(),
    );
  }
}

List<List<Tetromino?>> gameBoard =
    List.generate(colLength, (i) => List.generate(rowLength, (j) => null));

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentpiece = Piece(type: Tetromino.L);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startGame();
  }

  void startGame() {
    currentpiece.initializePiece();

    Duration frameRate = const Duration(milliseconds: 400);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        checkLanding();
        currentpiece.movingPiece(Directions.Down);
      });
    });
  }

  void checkLanding() {
    if (checkCollision(Directions.Down)) {
      for (int i = 0; i < currentpiece.position.length; i++) {
        int row = (currentpiece.position[i] / rowLength).floor();
        int col = currentpiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentpiece.type;
        }
      }

      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();

    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];

    currentpiece = Piece(type: randomType);
    currentpiece.initializePiece();
  }

  bool checkCollision(Directions directions) {
    for (int i = 0; i < currentpiece.position.length; i++) {
      int col = currentpiece.position[i] % rowLength;
      int row = (currentpiece.position[i] / rowLength).floor();

      if (directions == Directions.Left) {
        col--;
      } else if (directions == Directions.Right) {
        col++;
      } else if (directions == Directions.Down) {
        row++;
      }
      if (col < 0 || col >= rowLength || row >= colLength) {
        return true;
      }
      if (row >= 0 && gameBoard[row][col] != null) {
        return true;
      }
      // if (row >= colLength || colLength < 0 || colLength >= rowLength) {
      //   return true;
      // }
    }
    return false;
  }

  void moveLeft() {
    if (!checkCollision(Directions.Left)) {
      setState(() {
        currentpiece.movingPiece(Directions.Left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Directions.Right)) {
      setState(() {
        currentpiece.movingPiece(Directions.Right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentpiece.rotaePiece();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: [
          Expanded(
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rowLength * colLength,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLength),
                itemBuilder: (context, index) {
                  int col = index % rowLength;
                  int row = (index / rowLength).floor();

                  if (currentpiece.position.contains(index)) {
                    return Pixel(
                      color: currentpiece.color,
                      child: index.toString(),
                    );
                  } else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(
                        color: tetrominoColors[tetrominoType], child: '');
                  } else {
                    return Pixel(
                      color: Colors.grey[900],
                      child: index.toString(),
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // movingleft
                IconButton(
                    onPressed: moveLeft,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),

                //RotatingPiece
                IconButton(
                    onPressed: rotatePiece,
                    icon: const Icon(
                      Icons.rotate_right,
                      color: Colors.white,
                    )),

                //MovingRight
                IconButton(
                    onPressed: moveRight,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ]));
  }
}
