import 'dart:convert';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:test_game/constant.dart';
import 'package:test_game/fire_base_database.dart';
import 'package:test_game/get_it.dart';

class JoystickPlayer extends SpriteComponent
    with HasGameRef, CollisionCallbacks {
  /// Pixels/s
  double maxSpeed = 300.0;
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();

  final JoystickComponent joystick;

  JoystickPlayer(this.joystick)
      : super(size: Vector2.all(100.0), anchor: Anchor.center);

  final fireBase = getIt<FireBaseDatabase>();

  int a = 1;

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('idle.gif');
    position = Vector2(300, gameRef.size.y - 100);
    add(RectangleHitbox());
    var p = await fireBase.getPosition(fireBase.userId ?? 0);

    position.setFrom(Vector2(p.x as double, p.y as double));

    fireBase.listenChangePosition(
      1,
      onData: (event) {
        logger.v(event.snapshot.value);
        if (event.snapshot.value != null) {
          Map<String, dynamic> p = jsonDecode(jsonEncode(event.snapshot.value));

          position.setFrom(Vector2(p["x"] ?? 0, p["y"] ?? 0));
        }
      },
    );
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(Vector2(joystick.relativeDelta.x * maxSpeed * dt,
          joystick.relativeDelta.y * maxSpeed * dt));
      angle = joystick.delta.screenAngle();
      fireBase.updatePosition(
        fireBase.userId ?? 0,
        x: x,
        y: y,
      );
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    transform.setFrom(_lastTransform);
    size.setFrom(_lastSize);
  }
}
