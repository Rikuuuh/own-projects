import 'package:firebase_core/firebase_core.dart';
import 'package:flappy_bird_game/auth/main_page.dart';

import 'package:flutter/material.dart';

var colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(
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
      home: const MainPage(),
    ),
  );
}
