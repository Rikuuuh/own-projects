import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:naytto/front_page.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:naytto/ml_kansio/app_helper.dart';
import 'package:naytto/rh_kansio/auth_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//GetIt getIt = GetIt.instance;

//Teema
var houseColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 14, 195, 227),
);

//dark theme ei käytössä missään
var darkHouseColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 2, 38, 32),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // await AppHelper.firstRunCheck();
  initializeDateFormatting();
  runApp(
    MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fi', 'FI'),
      ],
      locale: const Locale('fi', 'FI'),
      theme: ThemeData().copyWith(
        colorScheme: houseColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 14, 195, 227),
            foregroundColor: houseColorScheme.secondaryContainer,
          ),
        ),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: houseColorScheme.inversePrimary,
          foregroundColor: houseColorScheme.onPrimaryContainer,
        ),
        scaffoldBackgroundColor: houseColorScheme.primaryContainer,
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: houseColorScheme.onSecondaryContainer,
                fontSize: 18,
              ),
              titleMedium: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                color: houseColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
              titleSmall: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                color: houseColorScheme.onSecondaryContainer,
                fontSize: 14,
              ),
            ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return const AuthScreen(); // Käyttäjä ei ole kirjautunut sisään
            }
            return const FrontPage(); // Käyttäjä on kirjautunut sisään
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
          );
        },
      ),
    ),
  );
}
