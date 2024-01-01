import 'package:flutter/material.dart';

class QuizResultsPage extends StatelessWidget {
  const QuizResultsPage({super.key, required this.score});
  final int score;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tietovisan loppu',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.green,
                fontSize: 20,
              ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 250,
                  width: 250,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    value: score / 9,
                    color: Colors.green,
                    backgroundColor: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      score.toString(),
                      style: const TextStyle(fontSize: 80),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            const Text(
              textAlign: TextAlign.center,
              'Kiitos osallistumisestasi!',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              textAlign: TextAlign.center,
              'Voit tarkistaa miten muilla on mennyt "Kisaajien Kunniajoukko" - välilehdestä',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
