import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_game/answer_card.dart';
import 'package:flappy_bird_game/auth/auth.dart';
import 'package:flappy_bird_game/data/questions.dart';
import 'package:flappy_bird_game/pages/quiz_results_page.dart';
import 'package:flutter/material.dart';

class QuizQuestionsPage extends StatefulWidget {
  const QuizQuestionsPage({super.key});

  @override
  State<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  int? selectedAnswerIndex;
  int questionIndex = 0;
  int score = 0;

  Timer? _timer;
  int _remainingTime = 30;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _remainingTime = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        goToNextQuestion();
      }
    });
  }

  void pickAnswer(int value) {
    _timer?.cancel();
    selectedAnswerIndex = value;
    final question = questions[questionIndex];
    if (selectedAnswerIndex == question.correctAnswerIndex) {
      score++;
    }
    setState(() {});
  }

  void goToNextQuestion() {
    if (questionIndex < questions.length - 1) {
      questionIndex++;
      selectedAnswerIndex = null;
      startTimer();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[questionIndex];
    bool isLastQuestion = questionIndex == questions.length - 1;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              question.question,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: selectedAnswerIndex == null
                      ? () => pickAnswer(index)
                      : null,
                  child: AnswerCard(
                    currentIndex: index,
                    question: question.options[index],
                    isSelected: selectedAnswerIndex != null,
                    selectedAnswerIndex: selectedAnswerIndex,
                    correctAnswerIndex: question.correctAnswerIndex,
                  ),
                );
              },
            ),
            isLastQuestion
                ? ElevatedButton(
                    onPressed: selectedAnswerIndex != null
                        ? () {
                            _timer?.cancel();
                            submitScore();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => QuizResultsPage(
                                  score: score,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(width: 1.2)),
                    ),
                    child: const Text('Lopeta Visa'),
                  )
                : ElevatedButton(
                    onPressed:
                        selectedAnswerIndex != null ? goToNextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(width: 1.2)),
                    ),
                    child: const Text('Seuraava'),
                  ),
            Text(
              'Vastaus aikaa jäljellä: $_remainingTime sekuntia',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> submitScore() async {
    var userDetails = await UserService.getUserDetails();
    String firstName = userDetails.firstName;
    User? user = FirebaseAuth.instance.currentUser;

    var database = FirebaseFirestore.instance;
    database
        .collection('visascores')
        .add({"userId": user?.uid, "name": firstName, "score": score});
  }
}
