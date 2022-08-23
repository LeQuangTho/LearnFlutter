import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:flutter/services.dart';
import 'package:test_game/joystick_player.dart';

final List<Map<LogicalKeyboardKey, LogicalKeyboardKey>> playersKeys = [
  {
    LogicalKeyboardKey.arrowUp: LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown: LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowLeft: LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight: LogicalKeyboardKey.arrowRight,
  },
  {
    LogicalKeyboardKey.keyW: LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.keyS: LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.keyA: LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.keyD: LogicalKeyboardKey.arrowRight,
  },
];

class RacingGame extends FlameGame with HasDraggables {
  SpriteComponent image1 = SpriteComponent();
  SpriteComponent image2 = SpriteComponent();
  SpriteComponent image3 = SpriteComponent();
  SpriteComponent image4 = SpriteComponent();
  SpriteComponent image5 = SpriteComponent();
  late final JoystickPlayer player;
  late final JoystickComponent joystick;
  late SpriteAnimationComponent animationComponent;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    image1
      ..sprite = await loadSprite("plx-1.png")
      ..size = Vector2(size.x, size.y);
    image2
      ..sprite = await loadSprite("plx-2.png")
      ..size = Vector2(size.x, size.y);
    image3
      ..sprite = await loadSprite("plx-3.png")
      ..size = Vector2(size.x, size.y);
    image4
      ..sprite = await loadSprite("plx-4.png")
      ..size = Vector2(size.x, size.y);
    image5
      ..sprite = await loadSprite("plx-5.png")
      ..size = Vector2(size.x, size.y);
    addAll([
      image1,
      image2,
      image3,
      image4,
      image5,
    ]);

    final knobPaint = BasicPalette.black.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.black.withAlpha(100).paint();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 70, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    player = JoystickPlayer(joystick);

    add(player);
    add(joystick);

    // final sprites = await fromJSONAtlas("layers/idle.png", "idle.json");
    // SpriteAnimation idle = SpriteAnimation.spriteList(sprites, stepTime: 0.05);
    // animationComponent = SpriteAnimationComponent()
    //   ..animation = idle
    //   ..position = Vector2(100, 100)
    //   ..size = Vector2(100, 100);

    // add(animationComponent);
  }
}
