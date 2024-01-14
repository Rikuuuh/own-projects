import 'package:flutter/material.dart';

class QuizResultsPage extends StatelessWidget {
  const QuizResultsPage({super.key, required this.score});
  final int score;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: Text(
          'Tuloksesi',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 22),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              textAlign: TextAlign.center,
              'Onneksi olkoon visan suorittamisesta!',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              'Tietovisan tulos : $score.',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              textAlign: TextAlign.center,
              'Olet todellinen visa-velho!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    value: score / 9,
                    color: Colors.green,
                    backgroundColor: Colors.redAccent,
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
              'Katso seuraavaksi mihin sijoitut Hall of Fame:ssa!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
