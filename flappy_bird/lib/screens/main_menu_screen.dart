import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatefulWidget {
  final FlappyBirdGame game;
  static const String id = 'mainMenu';

  const MainMenuScreen({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String? selectedBirdType;
  String? selectedBackgroundType;
  final List<String> birdImages = [
    'assets/images/bird1_midflap.png',
    'assets/images/bird2_midflap.png',
    'assets/images/bird5_midflap.png',
    'assets/images/bird3_midflap.png',
    'assets/images/bird4_midflap.png',
    'assets/images/bird6_midflap.png',
  ];

  final List<String> backgroundImages = [
    'assets/images/background1_done.png',
    'assets/images/background2_done.png',
    'assets/images/background3_done.png'
  ];

  void onBirdSelected(String birdType) {
    setState(() {
      selectedBirdType = birdType;
    });
  }

  void onBackgroundSelected(String backgroundType) {
    setState(() {
      selectedBackgroundType = backgroundType;
    });
  }

  // Score ei tuu
  // Ground ei tuu
  void onStartGamePressed() {
    // Logiikka pelin aloittamiseen valitulla linnulla
    if (selectedBirdType != null && selectedBackgroundType != null) {
      widget.game.startGameWithSelectedItems(
          selectedBirdType!, selectedBackgroundType!);
      widget.game.overlays.remove('mainMenu');
      widget.game.interval.reset();
      widget.game.resumeEngine();
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.game.pauseEngine();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Olympic Bird',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                letterSpacing: 2,
                fontSize: 50,
                fontFamily: 'game',
                shadows: [
                  const Shadow(
                    color: Colors.blueAccent,
                    blurRadius: 2.0,
                    offset: Offset(1.5, 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Valitse hahmosi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            GridView.builder(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              shrinkWrap: true,
              itemCount: birdImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                bool isSelected =
                    birdImages[index].split('/').last.split('_')[0] ==
                        selectedBirdType;
                return GestureDetector(
                  onTap: () => onBirdSelected(
                      birdImages[index].split('/').last.split('_')[0]),
                  child: Container(
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: Colors.cyan, width: 2.5)
                          : null,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1, // Säädä tarvittaessa
                      child:
                          Image.asset(birdImages[index], fit: BoxFit.fitWidth),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            Text(
              'Valitse maailmasi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            GridView.builder(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              shrinkWrap: true,
              itemCount: backgroundImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                bool isSelected =
                    backgroundImages[index].split('/').last.split('_')[0] ==
                        selectedBackgroundType;
                return GestureDetector(
                  onTap: () => onBackgroundSelected(
                      backgroundImages[index].split('/').last.split('_')[0]),
                  child: Container(
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: Colors.cyan, width: 2.5)
                          : null,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1, // Säädä tarvittaessa
                      child: Image.asset(backgroundImages[index],
                          fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: onStartGamePressed,
              child: const Text('Aloita peli'),
            ),
          ],
        ),
      ),
    );
  }
}
