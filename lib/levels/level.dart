import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/player.dart';

class Level extends World {
  final String levelName;
  final Player player;
  Level({required this.levelName,required this.player});
  late TiledComponent level;
  final player1 = Player(character: "Mask Dude");
  final player2 = Player(character: "Pink Man");

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load("$levelName.tmx", Vector2(16, 16));

    //Adding the level
    add(level);
    //Adding the player

    //Grapping the box on the tiled file and adding our player there

    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>("Spawnpoints");

    for (final spawnPoint in spawnPointLayer!.objects) {
      switch (spawnPoint.class_) {
        //the string "Player" was assigned as class to the object layer we created in Tiled
        case "Player":
           player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);

          break;
        default:
      }
    }

    return super.onLoad();
  }
}
