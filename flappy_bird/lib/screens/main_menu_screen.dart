import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flappy_bird_game/screens/count_down_overlay.dart';
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
  String howManyLeft = '20';
  String name = 'Riku';
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

  @override
  Widget build(BuildContext context) {
    widget.game.pauseEngine();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35.0),
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
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: <Widget>[
                Text(
                  'Valmiina haasteeseen?',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Olympic Bird kutsuu sinut $name kisaamaan!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Sinulla on $howManyLeft yritystä saada parempi tulos kuin muilla osallistujilla.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Onnea matkaan!',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Text(
              'Valitse maailmasi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
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
                          fit: BoxFit.fill),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: onStartGamePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: const Color.fromARGB(255, 56, 255, 225),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                textStyle: Theme.of(context).textTheme.titleMedium,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Aloita peli'),
            ),
            const SizedBox(height: 10),
            Text('$howManyLeft Yritystä jäljellä'),
          ],
        ),
      ),
    );
  }

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

  void onStartGamePressed() {
    late OverlayEntry overlayEntry;
    if (selectedBirdType == null || selectedBackgroundType == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Valitse hahmo ja tausta',
                style: TextStyle(color: Colors.black)),
            content: const Text(
                'Sinun täytyy valita hahmo ja tausta ennen kuin voit aloittaa pelin.',
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    overlayEntry = OverlayEntry(
      builder: (context) => CountdownOverlay(
        onCountdownComplete: () {
          overlayEntry.remove();
          startGame();
        },
      ),
    );
    Overlay.of(context).insert(overlayEntry);
  }

  void startGame() {
    // Logiikka pelin aloittamiseen valitulla linnulla
    if (selectedBirdType != null && selectedBackgroundType != null) {
      widget.game.startGameWithSelectedItems(
          selectedBirdType!, selectedBackgroundType!);
      widget.game.overlays.remove('mainMenu');
      widget.game.interval.reset();
      widget.game.resumeEngine();
    }
  }
}
