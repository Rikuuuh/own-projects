import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_game/auth/auth.dart';
import 'package:flappy_bird_game/main_drawer.dart';
import 'package:flappy_bird_game/pages/quiz_questions_page.dart';
import 'package:flappy_bird_game/pages/video_countdown_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? firstName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var userDetails = await UserService.getUserDetails();
    setState(() {
      firstName = userDetails.firstName;
    });
  }

  void _startQuiz(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizQuestionsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Tietovisa',
          style: TextStyle(fontSize: 24, color: Colors.green),
        ),
      ),
      drawer: const MainDrawer(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              radius: 100,
            ),
            const SizedBox(height: 20),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: <Widget>[
                Text(
                  '$firstName, onko sinulla sitä mitä vaaditaan mestariksi?',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Tämä on SINUN tilaisuutesi loistaa ja vastata kaikkiin kysymyksiin oikein!',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Kullakin kysymyksellä on aikaraja: sinulla on vain 30 sekuntia vastauksen antamiseen.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Katso mökkiolympialaisten parhaita hetkiä - video ja visa alkaa heti sen jälkeen!',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _startQuiz(context),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                textStyle: Theme.of(context).textTheme.titleMedium,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 1.5),
                ),
              ),
              child: const Text('Aloita Visa'),
            ),
          ],
        ),
      ),
    );
  }
}
