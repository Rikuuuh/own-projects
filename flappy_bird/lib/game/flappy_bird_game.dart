import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird_game/components/background.dart';
import 'package:flappy_bird_game/components/bird.dart';
import 'package:flappy_bird_game/components/ground.dart';
import 'package:flappy_bird_game/components/pipe.dart';
import 'package:flappy_bird_game/components/pipe_group.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flutter/material.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  FlappyBirdGame();

  late Bird bird;
  late Background background;
  late Ground ground;
  late Pipe pipe;
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  bool isHit = false;
  late TextComponent score;
  String selectedBirdType = 'bird1';
  String selectedBackgroundType = 'background1';
  String selectedGround = 'ground1_done.png';
  String selectedPipe = 'pipe1_norm.png';
  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
    score.text = 'Score: ${bird.score}';

    if (bird.score % 10 == 0 && bird.score != 0) {
      Config.gameSpeed = 220.0 + (bird.score / 10 * 10);
    }
  }

  void startGameWithSelectedItems(String birdType, String backgroundType) {
    selectedBirdType = birdType;
    selectedBackgroundType = backgroundType;
    removeAll(children);

    background = Background(selectedBackgroundType);
    add(background);

    String groundType = 'assets/images/ground1_done.png';
    String pipeType = 'assets/images/pipe1_norm.png';
    switch (selectedBackgroundType) {
      case "background1":
        groundType = "ground1_done.png";
        pipeType = "pipe1";
        break;
      case "background2":
        groundType = "ground2_done.png";
        pipeType = "pipe2";
        break;
      case "background3":
        groundType = "ground3_done.png";
        pipeType = "pipe3";
        break;
    }
    score.removeFromParent();
    score = buildScore();
    add(score);

    ground = Ground(groundType);
    add(ground);

    interval.onTick = () => add(PipeGroup(pipeType));

    bird.removeFromParent();
    bird = Bird(selectedBirdType);
    add(bird);

    isHit = false;
    interval.reset();
  }

  void resetGame() {
    removeAll(children);

    background = Background(selectedBackgroundType);
    add(background);

    String groundType = 'assets/images/ground1_done.png';
    String pipeType = 'assets/images/pipe1_norm.png';
    switch (selectedBackgroundType) {
      case "background1":
        groundType = "ground1_done.png";
        pipeType = "pipe1";
        break;
      case "background2":
        groundType = "ground2_done.png";
        pipeType = "pipe2";
        break;
      case "background3":
        groundType = "ground3_done.png";
        pipeType = "pipe3";
        break;
    }
    score = buildScore();
    add(score);
    ground = Ground(groundType);
    add(ground);
    interval.onTick = () => add(PipeGroup(pipeType));

    bird = Bird(selectedBirdType);
    add(bird);

    isHit = false;
    interval.reset();
  }

  @override
  Future<void> onLoad() async {
    addAll([
      Background(selectedBackgroundType),
      Ground(selectedGround),
      bird = Bird(selectedBirdType),
      score = buildScore(),
    ]);

    interval.onTick = () => add(PipeGroup(selectedPipe));
  }

  TextComponent buildScore() {
    return TextComponent(
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 45,
          fontFamily: 'Game',
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 2.0,
              offset: Offset(2.5, 2.5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onTap() {
    bird.fly();
  }
}
