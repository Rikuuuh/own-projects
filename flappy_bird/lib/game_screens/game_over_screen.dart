import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_game/game/assets.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird_game/auth/auth.dart';

class GameOverScreen extends StatelessWidget {
  final FlappyBirdGame game;
  GameOverScreen({super.key, required this.game});

  final User? user = Auth().currentUser;

  Future<void> submitScore() async {
    var userDetails = await UserService.getUserDetails();
    String firstName = userDetails.firstName;

    var database = FirebaseFirestore.instance;
    database.collection('highscores').add(
        {"userId": user?.uid, "name": firstName, "score": game.bird.score});
  }

  Future<void> decreaseAttempt(String userId) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw Exception("User not found!");
      }

      int currentAttempts = snapshot['attempts left'];
      if (currentAttempts > 0) {
        transaction.update(userRef, {'attempts left': currentAttempts - 1});
      } else {
        onMainMenu();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.black38,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score: ${game.bird.score}',
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontFamily: 'Game',
                ),
              ),
              const SizedBox(height: 25),
              Image.asset(Assets.gameOver),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onRestart,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Restart',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onMainMenu,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Main Menu',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  Future<int> getRemainingAttempts(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['attempts left'];
  }

  void onRestart() async {
    await submitScore();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    int attemptsLeft = await getRemainingAttempts(userId);

    if (attemptsLeft > 0) {
      await decreaseAttempt(userId);
      game.resetGame();
      Config.gameSpeed = 220.0;
      game.overlays.remove('gameOver');
      game.resumeEngine();
    } else {
      onMainMenu();
    }
  }

  void onMainMenu() async {
    await submitScore();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    int attemptsLeft = await getRemainingAttempts(userId);
    if (attemptsLeft > 0) {
      await decreaseAttempt(userId);
    }
    Config.gameSpeed = 220.0;
    game.bird.reset();
    game.overlays.remove('gameOver');
    game.overlays.add('mainMenu');
  }
}
