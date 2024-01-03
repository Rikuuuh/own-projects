import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird_game/auth/auth.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flappy_bird_game/game_screens/game_over_screen.dart';
import 'package:flappy_bird_game/game_screens/main_menu_screen.dart';
import 'package:flappy_bird_game/main_drawer.dart';
import 'package:flappy_bird_game/pages/home_page.dart';
import 'package:flappy_bird_game/pages/users_page.dart';
import 'package:flappy_bird_game/pages/video_countdown_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final User? user = Auth().currentUser;
  String? firstName;
  int? remainingAttempt;

  @override
  void initState() {
    super.initState();
    _loadRemainingAttempts();
    _loadUserData();
  }

  Future<void> _loadRemainingAttempts() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    int attempts = await getRemainingAttempts(userId);
    setState(() {
      remainingAttempt = attempts;
    });
  }

  Future<int> getRemainingAttempts(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['visa attempt'];
  }

  Future<void> _loadUserData() async {
    var userDetails = await UserService.getUserDetails();
    setState(() {
      firstName = userDetails.firstName;
    });
  }

  Future<void> decreaseAttempt(String userId) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw Exception("User not found!");
      }

      int currentAttempts = snapshot['visa attempt'];
      if (currentAttempts > 0) {
        transaction.update(userRef, {'visa attempt': currentAttempts - 1});
      } else {
        return const HomePage();
      }
    });
  }

  void _startQuiz(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    decreaseAttempt(userId).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VideoCountdownPage(),
        ),
      );
    }).catchError((error) {
      // Käsittele virhe täällä, esimerkiksi näyttämällä virheilmoitus
      log('Virhe vähentäessä yrityksiä: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        foregroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Tietovisa',
          style: TextStyle(fontSize: 24, color: Colors.green),
        ),
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 50.0,
                color: Colors.green,
              ),
              Text(
                'Tietäjien Taisto',
                style: GoogleFonts.bebasNeue(
                  color: Colors.green,
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      offset: Offset(1.5, 1.5),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoURL!),
                radius: 50,
              ),
              const SizedBox(height: 20),
              if (remainingAttempt != null && remainingAttempt! > 0) ...[
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Text(
                      '$firstName, onko sinulla sitä mitä vaaditaan mestariksi?',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Tämä on SINUN tilaisuutesi loistaa ja vastata kaikkiin kysymyksiin oikein!',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Kullakin kysymyksellä on aikaraja: sinulla on vain 30 sekuntia vastauksen antamiseen.',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Katso mökkiolympialaisten parhaita hetkiä video ja visa alkaa heti sen jälkeen!',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: () => _startQuiz(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5),
                    ),
                  ),
                  child: const Text('Aloita Video & Visa'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Psst! Laita äänet päälle ;)',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ] else if (remainingAttempt != null &&
                  remainingAttempt! == 0) ...[
                const SizedBox(height: 20),
                Text(
                  'Kiitos osallistumisestasi! Olet käyttänyt kaikki visayrityksesi',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Vaikka tietovisasi on ohi, voit silti nauttia Olympic Bird -pelistä',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startGame(context);
                  },
                  icon: const Icon(
                    Icons.sports_esports_outlined,
                    size: 30,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    'Olympic Bird peliin',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Katso muiden pelaajien tulokset Kisaajien Kunniajoukko-välilehdeltä tästä',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UsersPage()));
                  },
                  icon: const Icon(
                    Icons.emoji_events_outlined,
                    size: 30,
                    color: Colors.yellow,
                  ),
                  label: const Text(
                    'Kisaajien Kunniajoukkoon',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
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
