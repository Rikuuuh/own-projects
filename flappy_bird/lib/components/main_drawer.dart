import 'package:flame/game.dart';
import 'package:flappy_bird_game/auth/auth.dart';
import 'package:flappy_bird_game/auth/main_page.dart';
import 'package:flappy_bird_game/pages/home_page.dart';
import 'package:flappy_bird_game/pages/profile_page.dart';
import 'package:flappy_bird_game/pages/quiz.dart';
import 'package:flappy_bird_game/pages/view_users_page.dart';
import 'package:flappy_bird_game/game_screens/game_over_screen.dart';
import 'package:flappy_bird_game/game_screens/main_menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../game/flappy_bird_game.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});
  void startGame(BuildContext context) {
    final game = FlappyBirdGame();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return GameWidget(
          game: game,
          initialActiveOverlays: const [MainMenuScreen.id],
          overlayBuilderMap: {
            'mainMenu': (context, _) => MainMenuScreen(context, game: game),
            'gameOver': (context, _) => GameOverScreen(game: game),
          },
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 0, 29, 37),
      width: 255,
      surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 25),
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/icons/iconBird.png'),
                  radius: 70,
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  user!.email!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: Wrap(
              runSpacing: 16,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Olympialaisten aloitusalue',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.lightbulb_outlined,
                    size: 30,
                    color: Colors.green,
                  ),
                  title: Text(
                    'Tietovisa - Tietäjien Taisto',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.green,
                          fontSize: 20,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Quiz()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.sports_esports_outlined,
                    size: 30,
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Pelihetki - Olympic Bird',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    startGame(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.emoji_events_outlined,
                    size: 30,
                    color: Colors.yellow,
                  ),
                  title: Text(
                    'Kisaajien Kunniajoukko',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.yellow,
                          fontSize: 20,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UsersPage(),
                    ));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.orange,
                  ),
                  title: Text(
                    'Oma Profiili',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.orange,
                          fontSize: 20,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app_outlined,
                    size: 30,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    'Paluu Arkeen',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.redAccent,
                          fontSize: 20,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
