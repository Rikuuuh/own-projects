import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'package:flappy_bird_game/game/flappy_bird_game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Background(this.backgroundType);
  final String backgroundType;
  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load('${backgroundType}_done.png');
    size = gameRef.size;
    sprite = Sprite(background);
  }
}
