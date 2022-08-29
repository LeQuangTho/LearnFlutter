import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:test_game/fire_base_database.dart';
import 'package:test_game/get_it.dart';
import 'package:test_game/models/player.dart';

class JoystickPlayer extends FlameGame with HasGameRef, CollisionCallbacks {
  /// Pixels/s
  double maxSpeed = 300.0;
  late final Vector2 _lastSize = size.clone();

  // late final Transform2D _lastTransform = transform.clone();

  final JoystickComponent joystick;

  JoystickPlayer(this.joystick) : super();

  // : super(size: Vector2.all(100.0), anchor: Anchor.center);

  final fireBase = getIt<FireBaseDatabase>();

  int a = 1;

  @override
  Future<void> onLoad() async {
    // sprite = await gameRef.loadSprite('idle.gif');
    // add(RectangleHitbox());
    var p = await fireBase.getPosition(fireBase.userId ?? 0);

    // position.setFrom(Vector2(p.x as double, p.y as double));

    // fireBase.listenChangePosition(
    //   fireBase.userId ?? 0,
    //   onData: (event) {
    //     logger.v(event.snapshot.value);
    //     if (event.snapshot.value != null) {
    //       Map<String, dynamic> p = jsonDecode(jsonEncode(event.snapshot.value));
    //
    //       position.setFrom(Vector2(p["x"] ?? 0, p["y"] ?? 0));
    //     }
    //   },
    // );
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      _lastSize.setFrom(size);
      // _lastTransform.setFrom(transform);
      // position.add(Vector2(joystick.relativeDelta.x * maxSpeed * dt,
      //     joystick.relativeDelta.y * maxSpeed * dt));
      // angle = joystick.delta.screenAngle();
      var data = await fireBase.database
          .ref("/rooms/${fireBase.currentRoom}/users/${fireBase.userId}/position")
          .get();
      if (data.value != null) {
        Position position = Position.fromJson(data.value);
        fireBase.updatePosition(
          fireBase.userId ?? 0,
          x: (position.x as double) + joystick.relativeDelta.x * maxSpeed * dt,
          y: (position.y as double) + joystick.relativeDelta.y * maxSpeed * dt,
        );
      }
    }
  }
}
