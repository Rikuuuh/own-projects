import 'package:flame/game.dart';
import 'package:flappy_bird_game/auth/main_page.dart';
import 'package:flappy_bird_game/pages/home_page.dart';
import 'package:flappy_bird_game/pages/quiz.dart';
import 'package:flappy_bird_game/pages/users_page.dart';
import 'package:flappy_bird_game/game_screens/game_over_screen.dart';
import 'package:flappy_bird_game/game_screens/main_menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'game/flappy_bird_game.dart';

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
    final User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
      width: 275,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  if (user?.photoURL != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoURL!),
                      radius: 30,
                    )
                  else
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.png'),
                      radius: 30,
                    ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Olympialaisten',
                          style: Theme.of(context).textTheme.titleLarge!),
                      Text('Aloitusalue',
                          style: Theme.of(context).textTheme.titleLarge!),
                    ],
                  ),
                ],
              ),
            ),
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Quiz()));
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
            onTap: () => startGame(context),
          ),
          const Spacer(),
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
          const Spacer(),
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
              FirebaseAuth.instance.signOut();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MainPage(),
              ));
            },
          )
        ],
      ),
    );
  }
}
