import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_game/auth/auth.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flappy_bird_game/game_screens/count_down_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MainMenuScreen extends StatefulWidget {
  final FlappyBirdGame game;
  static const String id = 'mainMenu';

  const MainMenuScreen(BuildContext context, {super.key, required this.game});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final User? user = Auth().currentUser;
  String? firstName;
  int? remainingAttempts;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRemainingAttempts();
  }

  Future<void> _loadRemainingAttempts() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    int attempts = await getRemainingAttempts(userId);
    setState(() {
      remainingAttempts = attempts;
    });
  }

  Future<int> getRemainingAttempts(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['attempts left'];
  }

  Future<void> _loadUserData() async {
    var userDetails = await UserService.getUserDetails();
    setState(() {
      firstName = userDetails.firstName;
    });
  }

  Future<void> showHighScores(BuildContext context) async {
    var highscores = await FirebaseFirestore.instance
        .collection("highscores")
        .orderBy("score", descending: true)
        .limit(10)
        .get();

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          backgroundColor: Colors.deepPurple[100],
          title: const Text(
            'Tämän hetken 10 parasta',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: highscores.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var scoreData = highscores.docs[index].data();
                return ListTile(
                  title: Text(
                    '${scoreData['name']}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    '${scoreData['score']}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Sulje',
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
  }

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Olympic Bird',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  letterSpacing: 2,
                  fontSize: 55,
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
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Text(
                    'Valmiina haasteeseen $firstName?',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Olympic Bird kutsuu sinut kisaamaan!',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Sinulla on 50 yritystä saada parempi tulos kuin muilla osallistujilla.',
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
              const SizedBox(height: 12),
              Text(
                'Valitse hahmosi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
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
                            ? Border.all(
                                color: const Color.fromARGB(255, 200, 225, 255),
                                width: 2.5)
                            : null,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(birdImages[index],
                            fit: BoxFit.fitWidth),
                      ),
                    ),
                  );
                },
              ),
              Text(
                'Valitse maailmasi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
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
                            ? Border.all(
                                color: const Color.fromARGB(255, 200, 225, 255),
                                width: 2.5)
                            : null,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(backgroundImages[index],
                            fit: BoxFit.fill),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: onStartGamePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: const Color.fromARGB(255, 56, 255, 225),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 11),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 56, 255, 225),
                          width: 1.5)),
                ),
                child: const Text('Aloita peli'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 11),
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: const Text('Poistu pelistä'),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () {
                      showHighScores(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 42, vertical: 11),
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5),
                      ),
                    ),
                    child: const Text('Tulokset'),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text('$remainingAttempts Yritystä jäljellä'),
            ],
          ),
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

  void onStartGamePressed() async {
    if (selectedBirdType == null || selectedBackgroundType == null) {
      _showDialog();
      return;
    }
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    int attemptsLeft = await getRemainingAttempts(userId);
    if (attemptsLeft == 0) {
      // Näytä ilmoitus, ettei yrityksiä ole jäljellä
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            '50 yrityksen raja tuli vastaan! ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          icon: const Icon(Icons.bedtime),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      late OverlayEntry overlayEntry;
      overlayEntry = OverlayEntry(
        builder: (context) => CountdownOverlay(
          onCountdownComplete: () {
            overlayEntry.remove();
            startGame();
          },
        ),
      );
      // ignore: use_build_context_synchronously
      Overlay.of(context).insert(overlayEntry);
    }
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

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Valitse hahmo ja tausta'),
          content: const Text(
              'Sinun täytyy valita hahmo ja tausta ennen kuin voit aloittaa pelin'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Valitse hahmo ja tausta',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text(
              'Sinun täytyy valita hahmo ja tausta ennen kuin voit aloittaa pelin',
              style: TextStyle(
                color: Colors.white,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
