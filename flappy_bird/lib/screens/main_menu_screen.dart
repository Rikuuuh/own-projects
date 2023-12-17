//import 'package:flappy_bird_game/game/assets.dart';
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
    // Lisää kuvatiedostojen nimet tähän
  ];

  MainMenuScreen({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    game.pauseEngine();
    return Scaffold(
      body: GridView.builder(
        itemCount: birdImages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Muuta tämä arvo sopivaksi ruudukon kokoon
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              String selectedBirdType = birdImages[index].split('_')[
                  0]; // Olettaen, että lintutyyppi on tiedostonimen ensimmäinen osa
              game.startGameWithSelectedBird(selectedBirdType);
              game.overlays.remove('mainMenu');
              game.resumeEngine();
              print(selectedBirdType);
            },
            child: Image.asset(birdImages[index]),
          );
        },
      ),
    );
  }
}
