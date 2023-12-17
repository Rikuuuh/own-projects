import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird_game/components/background.dart';
import 'package:flappy_bird_game/components/bird.dart';
import 'package:flappy_bird_game/components/clouds.dart';
import 'package:flappy_bird_game/components/ground.dart';
import 'package:flappy_bird_game/components/pipe_group.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flutter/painting.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  FlappyBirdGame();

  late Bird bird;
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  bool isHit = false;
  late TextComponent score;
  String selectedBirdType = 'bird';
  void startGameWithSelectedBird(String birdType) {
    selectedBirdType = birdType;
    bird.removeFromParent(); // Poista vanha lintu
    bird = Bird(selectedBirdType); // Luo uusi lintu valitulla tyypillä
    add(bird); // Lisää uusi lintu peliin
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
    score.text = 'Score: ${bird.score}';

    if (bird.score % 10 == 0 && bird.score != 0) {
      // Kasvata gameSpeedia 10 yksiköllä jokaista kymmentä pistettä kohden
      Config.gameSpeed = 220.0 + (bird.score / 10 * 10);
    }
  }

  @override
  Future<void> onLoad() async {
    addAll([
      Background(),
      Ground(),
      Clouds(),
      bird = Bird(selectedBirdType),
      score = buildScore(),
    ]);

    interval.onTick = () => add(PipeGroup());
  }

  TextComponent buildScore() {
    return TextComponent(
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
            fontSize: 40, fontFamily: 'Game', fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void onTap() {
    bird.fly();
  }
}
