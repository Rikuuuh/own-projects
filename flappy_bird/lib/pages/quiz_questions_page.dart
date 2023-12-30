import 'package:flappy_bird_game/data/questions.dart';
import 'package:flappy_bird_game/model/quiz_question.dart';
import 'package:flappy_bird_game/pages/quiz_results_page.dart';
import 'package:flappy_bird_game/quiz_answerbutton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizQuestionsPage extends StatefulWidget {
  const QuizQuestionsPage({super.key});
  @override
  QuizQuestionsPageState createState() => QuizQuestionsPageState();
}

class QuizQuestionsPageState extends State<QuizQuestionsPage> {
  var currentQuestionIndex = 0;
  final List<String> selectedAnswers = [];
  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);

    if (selectedAnswers.length == questions.length) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QuizResultsPage(chosenAnswers: selectedAnswers),
        ),
      );
    }
  }

  void answerQuestion(String selectedAnswer) {
    chooseAnswer(selectedAnswer);

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return _buildQuestion(questions[index], index);
        },
        onPageChanged: (index) {
          setState(() {
            currentQuestionIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildQuestion(QuizQuestion question, int questionIndex) {
    final currentQuestion = questions[currentQuestionIndex];
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: GoogleFonts.bebasNeue(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40,
            ),
            ...currentQuestion.shuffledAnswers.map(
              (item) {
                return AnswerButton(
                  answerText: item,
                  onTap: () {
                    answerQuestion(item);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
