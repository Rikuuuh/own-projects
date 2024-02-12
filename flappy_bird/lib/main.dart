import 'package:firebase_core/firebase_core.dart';
import 'package:flappy_bird_game/auth/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

// Main.dart, eli täällä luodaan teemat joita käytössä joka sivulla apissa.

var colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
              titleLarge: GoogleFonts.baloo2(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSecondaryContainer,
                fontSize: 18,
              ),
              titleMedium:
                  GoogleFonts.baloo2(color: colorScheme.onSecondaryContainer),
              bodyMedium:
                  GoogleFonts.baloo2(color: colorScheme.onSecondaryContainer),
              bodyLarge:
                  GoogleFonts.baloo2(color: colorScheme.onSecondaryContainer),
            ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 1, 40, 51),
        iconTheme: const IconThemeData()
            .copyWith(color: colorScheme.onPrimaryContainer),
        canvasColor: colorScheme.secondaryContainer,
        inputDecorationTheme: InputDecorationTheme(
          prefixStyle:
              GoogleFonts.baloo2(color: colorScheme.onSecondaryContainer),
          suffixStyle:
              GoogleFonts.baloo2(color: colorScheme.onSecondaryContainer),
        ),
      ),
      home: const MainPage(),
    ),
  );
}
