import 'package:flame/game.dart';
import 'package:flappy_bird_game/auth/main_page.dart';
import 'package:flappy_bird_game/pages/home_page.dart';
import 'package:flappy_bird_game/pages/users_page.dart';
import 'package:flappy_bird_game/screens/game_over_screen.dart';
import 'package:flappy_bird_game/screens/main_menu_screen.dart';
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
      width: 275,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
            },
            child: DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  if (user?.photoURL != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoURL!),
                      radius: 24,
                    )
                  else
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.png'),
                      radius: 24,
                    ),
                  const SizedBox(width: 18),
                  Text(
                    'Etusivu',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.format_list_bulleted,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Olympialais visa',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.leaderboard,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Olympic Bird - Peli',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () => startGame(context),
          ),
          const Spacer(),
          ListTile(
            leading: Icon(
              Icons.tag_faces_sharp,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Osallistujat',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const UsersPage(),
              ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Kirjaudu ulos',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
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
