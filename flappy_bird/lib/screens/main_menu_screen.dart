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
  final List<String> birdImages = [
    'assets/images/bird1_midflap.png',
    'assets/images/bird2_midflap.png',
    'assets/images/bird5_midflap.png',
    'assets/images/bird3_midflap.png',
    'assets/images/bird4_midflap.png',
    'assets/images/bird6_midflap.png',
  ];

  void onBirdSelected(String birdType) {
    setState(() {
      selectedBirdType = birdType;
    });
  }

  void onStartGamePressed() {
    if (selectedBirdType == null) Center(child: Text('Valitse lintu ensiksi!'));
    // Logiikka pelin aloittamiseen valitulla linnulla
    if (selectedBirdType != null) {
      widget.game.startGameWithSelectedBird(selectedBirdType!);
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
              'Valitse sankarisi',
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
                return ElevatedButton(
                  onPressed: () => onBirdSelected(
                      birdImages[index].split('/').last.split('_')[0]),
                  style: ElevatedButton.styleFrom(
                    side: isSelected
                        ? const BorderSide(width: 2.5, color: Colors.cyan)
                        : null,
                  ),
                  child: Image.asset(birdImages[index]),
                );
              },
            ),
            const SizedBox(height: 5),
            Text(
              'Valitse Taustasi',
              style: Theme.of(context).textTheme.titleLarge,
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
