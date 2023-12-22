// import 'package:flame/game.dart';
// import 'package:flappy_bird_game/screens/game_over_screen.dart';
// import 'package:flappy_bird_game/screens/main_menu_screen.dart';
import 'package:flappy_bird_game/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

// import 'game/flappy_bird_game.dart';

// Widget mainMenuScreenWrapper(BuildContext context, Object? game) {
//   return MainMenuScreen(game: game as FlappyBirdGame);
// }

var colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final game = FlappyBirdGame();
  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: colorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSecondaryContainer,
                fontSize: 18,
              ),
              titleMedium: TextStyle(color: colorScheme.onSecondaryContainer),
              bodyMedium: TextStyle(color: colorScheme.onSecondaryContainer),
              bodyLarge: TextStyle(color: colorScheme.onSecondaryContainer),
            ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 1, 40, 51),
        iconTheme: const IconThemeData()
            .copyWith(color: colorScheme.onPrimaryContainer),
        canvasColor: colorScheme.secondaryContainer,
        inputDecorationTheme: InputDecorationTheme(
          prefixStyle: TextStyle(color: colorScheme.onSecondaryContainer),
          suffixStyle: TextStyle(color: colorScheme.onSecondaryContainer),
        ),
      ),
      home: const WidgetTree(),
      // home: GameWidget(
      //   game: game,
      //   initialActiveOverlays: const [MainMenuScreen.id],
      //   overlayBuilderMap: {
      //     'mainMenu': (context, _) => mainMenuScreenWrapper(context, game),
      //     'gameOver': (context, _) => GameOverScreen(game: game),
      //   },
      // ),
    ),
  );
}
