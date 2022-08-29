import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:test_game/constant.dart';
import 'package:test_game/models/player.dart';

class FireBaseDatabase {
  late FirebaseDatabase database;
  int? currentRoom;
  int? userId;

  FireBaseDatabase() {
    database = FirebaseDatabase.instance;
  }

  updatePosition(int userId, {double x = 0, double y = 0}) {
    final ref = database.ref("/rooms/$currentRoom/users/$userId");
    ref.update({
      "position": {
        "x": x,
        "y": y,
      }
    });
  }

  Future<Point> getPosition(int userId) async {
    final ref = database.ref("/rooms/$currentRoom/users/$userId/position");

    var data = await ref.get();

    Map<String, dynamic> position = jsonDecode(jsonEncode(data.value));

    return Point(position["x"] ?? 0.1, position["y"] ?? 0.1);
  }

  listenChangePosition(int userId, {Function(DatabaseEvent)? onData}) {
    final ref = database.ref("/rooms/$currentRoom/users/$userId/position");

    ref.onValue.listen(onData);
  }

  Future checkRoom() async {
    final ref = database.ref("/rooms");
    var data = await ref.get();
    if (data.value == null) {
      await initRoom();
      userId = 0;
    } else {
      List rooms = jsonDecode(jsonEncode(data.value));
      currentRoom = Random().nextInt(rooms.length);
      await initUser();
    }
    logger.d("currentRoom: $currentRoom, userId: $userId");
  }

  Future initRoom() async {
    final ref = database.ref("/rooms");
    await ref.set({
      "0": {
        "users": {
          "0": {
            "position": {
              "x": 0.1,
              "y": 0.1,
            }
          }
        }
      }
    });

    currentRoom = 0;

    var data = await ref.get();

    logger.d(data.value);
  }

  Future<void> initUser() async {
    final ref = database.ref("/rooms/$currentRoom/users");
    var data = await ref.get();
    List users = jsonDecode(jsonEncode(data.value));
    await database.ref("/rooms/$currentRoom/users/${users.length}").set({
      "position": {
        "x": 0.1,
        "y": 0.1,
      }
    });

    userId = users.length;
  }

  listenRoom(Function(DatabaseEvent event) listen) {
    database.ref("/rooms/$currentRoom/users").onChildAdded.listen(listen);
  }

  listenUserRoom(Function(List<Player> player) listen) async {
    var data = await database.ref("/rooms/$currentRoom/users").get();
    if (data.value != null) {
      List<Player> players = List<Player>.from(
              jsonDecode(jsonEncode(data.value)).map((e) => Player.fromJson(e)))
          .toList();
      if (userId != null) {
        players.removeAt(userId!);
      }
      listen(players);
    }
  }

  Future<void> clearRoom() async {
    final ref = database.ref("/rooms/$currentRoom/users");
    await ref.set([]);
  }

  Future<int> getSumPlayer() async {
    var data = await database.ref("/rooms/$currentRoom/users").get();

    List users = jsonDecode(jsonEncode(data.value));
    return users.length;
  }
}
