import 'package:flutter/material.dart';

import 'package:flappy_bird_game/game/assets.dart';

// Widget "overlay", joka näkyy Olympic Bird aloita pelin nappia painaessa.
// Kestää 5 sec for loop
class CountdownOverlay extends StatefulWidget {
  final VoidCallback onCountdownComplete;

  const CountdownOverlay({super.key, required this.onCountdownComplete});

  @override
  CountdownOverlayState createState() => CountdownOverlayState();
}

class CountdownOverlayState extends State<CountdownOverlay> {
  int countdown = 5;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() async {
    for (int i = 5; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          countdown = i - 1;
        });
      }
    }
    widget.onCountdownComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.95)),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Valmistaudu',
                  style: TextStyle(
                    fontSize: 55,
                    color: Colors.white,
                    fontFamily: 'Game',
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  countdown > 0 ? countdown.toString() : '',
                  style: const TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Game',
                  ),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  Assets.message,
                  scale: 0.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
