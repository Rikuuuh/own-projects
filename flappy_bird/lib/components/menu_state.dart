import 'package:flame/game.dart';
import 'package:flappy_bird_game/components/menu_page.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flappy_bird_game/game_screens/game_over_screen.dart';
import 'package:flappy_bird_game/game_screens/main_menu_screen.dart';
import 'package:flappy_bird_game/model/menu_item.dart';
import 'package:flappy_bird_game/pages/home_page.dart';
import 'package:flappy_bird_game/pages/profile_page.dart';
import 'package:flappy_bird_game/pages/quiz.dart';
import 'package:flappy_bird_game/pages/view_users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

// Drawerin ylin widget

class MenuState extends StatefulWidget {
  const MenuState({super.key});

  @override
  State<MenuState> createState() => _MenuStateState();
}

class _MenuStateState extends State<MenuState> {
  MenuItem currentItem = MenuItems.etusivu;

  @override
  Widget build(BuildContext context) => ZoomDrawer(
        menuBackgroundColor: const Color.fromARGB(255, 1, 40, 51),
        borderRadius: 50,
        angle: -3,
        slideWidth: MediaQuery.of(context).size.width * 0.70,
        showShadow: true,
        shadowLayer1Color: Colors.white10,
        shadowLayer2Color: Colors.black54,
        menuScreen: Builder(
          builder: (context) => MenuPage(
            currentItem: currentItem,
            onSelectedItem: (item) {
              setState(() => currentItem = item);
              if (item == MenuItems.birdpeli) {
                startGame(context);
              }
              ZoomDrawer.of(context)!.close();
            },
          ),
        ),
        mainScreen: getScreen(),
      );

  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.etusivu:
        return const HomePage();
      case MenuItems.tietovisa:
        return const Quiz();
      case MenuItems.userspage:
        return UsersPage();
      case MenuItems.profilepage:
        return const ProfilePage();
    }
    return const HomePage();
  }

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
}
