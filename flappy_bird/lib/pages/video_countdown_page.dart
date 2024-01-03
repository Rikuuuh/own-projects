import 'package:flappy_bird_game/pages/quiz_questions_page.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird_game/pages/video_countdown_overlay.dart';

class VideoCountdownPage extends StatelessWidget {
  const VideoCountdownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: VideoCountdown(
        onVideoComplete: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuizQuestionsPage()),
          );
        },
      ),
    );
  }
}
