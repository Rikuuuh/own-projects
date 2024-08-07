// Unohtuiko salasana? painikkeella pääsee tähän widgettiin.
// Käyttäjä pystyy vaihtamaan unohtamansa salasanan.
// Käytössä login_page.dart:issa

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          content: const Text(
              'Salasanan vaihto linkki lähetetty! Tarkista sähköpostisi.',
              style: TextStyle(
                color: Colors.black,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: const Text(
              'Salasanan vaihto linkki lähetetty! Tarkista sähköpostisi.',
              style: TextStyle(
                color: Colors.black,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      _showDialog();
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(e.message.toString(),
              style: const TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restore_outlined,
              size: 100,
            ),
            const SizedBox(
              height: 75,
            ),
            Text(
              'Resetoi salasanasi',
              style: GoogleFonts.bebasNeue(fontSize: 52),
            ),
            const SizedBox(
              height: 25,
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Sähköposti',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                  EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 15),
                ),
              ),
              onPressed: passwordReset,
              child: Text(
                'Vaihda salasanasi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ));
  }
}
