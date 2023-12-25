import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_game/auth/auth_page.dart';
import 'package:flappy_bird_game/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const ProfilePage();
            } else {
              return const AuthPage();
            }
          }),
    );
  }
}
