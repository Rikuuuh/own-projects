import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_game/auth/auth_page.dart';
import 'package:flappy_bird_game/components/menu_state.dart';

import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  // Streambuilder, jos käyttäjä ei ole kirjautunut niin näytetään
  // login / register screen
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const AuthPage(); // Käyttäjä ei ole kirjautunut sisään
          }
          return const MenuState(); // Käyttäjä on kirjautunut sisään
        }
        return const Scaffold(
          body: Center(
              child: CircularProgressIndicator(
            strokeAlign: BorderSide.strokeAlignCenter,
          )),
        );
      },
    );
  }
}
