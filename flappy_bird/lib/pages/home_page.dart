import 'package:flutter/material.dart';
import 'package:flappy_bird_game/main_drawer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _title() {
    return const Text('Olympialaiset');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      drawer: const MainDrawer(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/miehet.png',
                      fit: BoxFit.fill, // Kuvan sovitus
                      width: 140, // Kuvan leveys
                      height: 180, // Kuvan korkeus
                    ).animate(effects: [
                      const FadeEffect(
                          begin: .1, end: 1, duration: Duration(seconds: 2)),
                    ]),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/naiset.png',
                      fit: BoxFit.fill, // Kuvan sovitus
                      width: 140, // Kuvan leveys
                      height: 180, // Kuvan korkeus
                    ).animate(effects: [
                      const FadeEffect(
                          begin: .1, end: 1, duration: Duration(seconds: 2)),
                    ]),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
