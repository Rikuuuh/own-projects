import 'package:flutter/material.dart';
import 'package:flappy_bird_game/main_drawer.dart';

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
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/miehet.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Image.asset(
                    'assets/images/naiset.png',
                    fit: BoxFit.contain,
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
