import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_game/auth/auth.dart';
import 'package:flappy_bird_game/components/menu_widget.dart';
import 'package:flappy_bird_game/pages/home_page.dart';
import 'package:flappy_bird_game/components/video_countdown_page.dart';
import 'package:flutter/material.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: Text(
          'Tietovisa',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 22),
        ),
        leading: const MenuWidget(),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.psychology_alt_outlined,
                size: 80,
                color: Colors.green,
              ),
              Text(
                'Tietäjien Taisto',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 50, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              CircleAvatar(
                backgroundImage: user != null && user?.photoURL != null
                    ? NetworkImage(user!.photoURL!) as ImageProvider<Object>
                    : const AssetImage("assets/icons/iconBird.png")
                        as ImageProvider<Object>,
                radius: 70,
              ),
              const SizedBox(height: 15),
              if (remainingAttempt != null && remainingAttempt! > 0) ...[
                Wrap(
                  spacing: 25,
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
                    const SizedBox(height: 20),
                    Text(
                      'Kullakin kysymyksellä on aikaraja: sinulla on vain 30 sekuntia vastauksen antamiseen.',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Seuraa videota tarkalla silmällä, kysymyksissä saatetaan kysyä videolla näkyviä tapahtumia',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
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
                        horizontal: 40, vertical: 15),
                    textStyle: Theme.of(context).textTheme.titleMedium,
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
                  'Kiitos osallistumisestasi! Olet jo käyttänyt visayrityksesi',
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
                const SizedBox(height: 25),
                Text(
                  'Katso muiden pelaajien tuloksia Hall of Fame-välilehdeltä',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
