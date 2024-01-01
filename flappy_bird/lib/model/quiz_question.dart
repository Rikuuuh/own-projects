class Question {
  // Constructor, joka ottaa vastaan datan

  // kaksi luokkamuuttujaa, kysymys ja lista vastauksia
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const Question({
    required this.question,
    required this.correctAnswerIndex,
    required this.options,
  });
}
