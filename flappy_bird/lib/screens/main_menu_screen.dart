import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  final FlappyBirdGame game;
  static const String id = 'mainMenu';

  final List<String> birdImages = [
    'assets/images/lintu_midflap.png',
    'assets/images/lintu2_midflap.png',
    'assets/images/lintu3_midflap.png',
    'assets/images/bird_midflap.png',
  ];

  MainMenuScreen({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    game.pauseEngine();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: birdImages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                String selectedBirdType =
                    birdImages[index].split('/').last.split('_')[0];
                game.startGameWithSelectedBird(selectedBirdType);
                game.overlays.remove('mainMenu');
                game.interval.reset();
                game.resumeEngine();
              },
              child: Image.asset(birdImages[index]),
            );
          },
        ),
      ),
    );
  }
}
