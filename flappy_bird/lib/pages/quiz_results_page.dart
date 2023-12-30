import 'package:flappy_bird_game/data/questions.dart';
import 'package:flappy_bird_game/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizResultsPage extends StatelessWidget {
  const QuizResultsPage({super.key, required this.chosenAnswers});

  final List<String> chosenAnswers;

  // Map on datarakenne, jossa voidaan määritellä key: value pareja
  // Esim ikä(key): 33(value)

  // List<Map<String, Object>> getSummaryData() {
  List<Map<String, Object>> get summaryData {
    final List<Map<String, Object>> summary = []; // Luodaan lista

    // Generoidaan data...
    for (var i = 0; i < chosenAnswers.length; i++) {
      // For loop body
      summary.add({
        //key: value
        'question_index': i,
        'question': questions[i].text,
        'correct_answer': questions[i].answers[0],
        'user_answer': chosenAnswers[i],
      });
    }

    return summary; // Palautetaan lista
  }

  @override
  Widget build(BuildContext context) {
    // Luodaan muuttujat, jossa on kaikkien kysymyksien lukumäärä ja
    // oikeiden vastauksien lukumäärä.

    final numTotalQuestions = questions.length;
    final numCorrectQuestions = summaryData
        .where(
          (elementData) =>
              elementData['user_answer'] == elementData['correct_answer'],
          // Where funktion sisällä pitää suorittaa funktio joka palauttaa
          // true tai false. true säilyttää datan ja false hylkää datan.
          // Where suodattaa alkuperäisen listan dataa ja palauttaa uuden
          // suodatetun listan.
        )
        .length;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly!',
                style: GoogleFonts.saira(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  },
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
                  child: const Text('Palaa kotiin'))
            ],
          ),
        ),
      ),
    );
  }
}
