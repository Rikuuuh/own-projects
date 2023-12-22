import 'package:flappy_bird_game/main_drawer.dart';
import 'package:flappy_bird_game/pages/profile_page.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _title() {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        'Olympialaiset',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      drawer: const MainDrawer(),
      body: const ProfilePage(),
    );
  }
}
