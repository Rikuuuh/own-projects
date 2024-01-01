import 'package:flutter/material.dart';

class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.question,
    required this.isSelected,
    required this.currentIndex,
    required this.correctAnswerIndex,
    required this.selectedAnswerIndex,
  });

  final String question;
  final bool isSelected;
  final int? correctAnswerIndex;
  final int? selectedAnswerIndex;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    bool isCorrectAnswer =
        selectedAnswerIndex != null && currentIndex == correctAnswerIndex;
    bool isWrongAnswer =
        selectedAnswerIndex != null && !isCorrectAnswer && isSelected;
    bool isUserSelected = selectedAnswerIndex == currentIndex;

    Color? backgroundColor = isUserSelected
        ? (isCorrectAnswer ? Colors.green[100] : Colors.red[100])
        : Colors.blueGrey[500];

    Color borderColor = selectedAnswerIndex != null
        ? (isCorrectAnswer
            ? Colors.green
            : isWrongAnswer
                ? Colors.red
                : Colors.white24)
        : Colors.white24;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            if (isCorrectAnswer)
              buildCorrectIcon()
            else if (isWrongAnswer)
              buildWrongIcon(),
          ],
        ),
      ),
    );
  }

  Widget buildCorrectIcon() => const CircleAvatar(
        radius: 15,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      );

  Widget buildWrongIcon() => const CircleAvatar(
        radius: 15,
        backgroundColor: Colors.red,
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
      );
}
