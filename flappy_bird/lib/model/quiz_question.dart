// Luokka question, käytössä Quiz pelissä, quiz_questions_page.dart:issa.
class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const Question({
    required this.question,
    required this.correctAnswerIndex,
    required this.options,
  });
}
