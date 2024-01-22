import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird_game/game/assets.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flappy_bird_game/game/pipe_position.dart';
import 'package:flappy_bird_game/game_components/pipe.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup(this.pipeType);

  final _random = Random();
  String pipeType;

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    const baseSpacing = 220;
    final maxRandomSpacing = heightMinusGround / 6;
    final spacing = baseSpacing + _random.nextDouble() * maxRandomSpacing;

    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing - 40);

    addAll([
      Pipe(
          pipePosition: PipePosition.top,
          height: centerY - spacing / 1.8,
          pipeType: pipeType),
      Pipe(
          pipePosition: PipePosition.bottom,
          height: heightMinusGround - (centerY + spacing / 3),
          pipeType: pipeType),
    ]);
  }

  void updateScore() {
    const Map<int, String> scoreSounds = {
      100: Assets.unstoppable,
      200: Assets.godlike,
      300: Assets.holyshit,
      400: Assets.oneandonly,
    };
    FlameAudio.play(Assets.point, volume: 0.2);
    gameRef.bird.score += 5;
    String? soundToPlay = scoreSounds[gameRef.bird.score];
    if (soundToPlay != null) {
      FlameAudio.play(soundToPlay);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -10) {
      removeFromParent();
      updateScore();
    }

    if (gameRef.isHit == true) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }
}
