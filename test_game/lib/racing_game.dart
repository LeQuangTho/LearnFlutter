import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Image, Gradient;
import 'package:test_game/constant.dart';
import 'package:test_game/fire_base_database.dart';
import 'package:test_game/get_it.dart';
import 'package:test_game/joystick_player.dart';

class RacingGame extends FlameGame with HasDraggables {
  SpriteComponent image1 = SpriteComponent();
  SpriteComponent image2 = SpriteComponent();
  SpriteComponent image3 = SpriteComponent();
  SpriteComponent image4 = SpriteComponent();
  SpriteComponent image5 = SpriteComponent();
  late final JoystickPlayer player;
  late final JoystickComponent joystick;
  late SpriteAnimationComponent animationComponent;
  FireBaseDatabase fireBase = getIt<FireBaseDatabase>();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await fireBase.checkRoom();

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

    fireBase.listenRoom(fireBase.currentRoom ?? 0, (event) async {
      // SpriteComponent image6 = SpriteComponent();
      // image6..sprite = await loadSprite("jump.png")
      //   ..size = Vector2(100, 100)
      //   ..position = Vector2(100, 100);
      // add(image6);
      logger.d(event.snapshot.value);
    });

    // final sprites = await fromJSONAtlas("layers/idle.png", "idle.json");
    // SpriteAnimation idle = SpriteAnimation.spriteList(sprites, stepTime: 0.05);
    // animationComponent = SpriteAnimationComponent()
    //   ..animation = idle
    //   ..position = Vector2(100, 100)
    //   ..size = Vector2(100, 100);

    // add(animationComponent);
  }
}
