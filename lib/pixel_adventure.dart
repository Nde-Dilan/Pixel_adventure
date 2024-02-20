import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/levels/level.dart';

//tell Flame to listen to keyBoard events
class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;

  Player player = Player(character: "Ninja Frog");

  late JoystickComponent joystick;

  bool shoJoystick = true;

  @override
  FutureOr<void> onLoad() async {
    //Adding images to cache
    await images.loadAllImages();

    //The world where our map is found
    final myWorld = Level(levelName: "Level-02", player: player);

    cam = CameraComponent.withFixedResolution(
        world: myWorld, width: 640, height: 360);

    //Change the starting point of the camera
    cam.viewfinder.anchor = Anchor.topLeft;

    // print("Loading....");

    addAll([cam, myWorld]);

    //Add joystick
    if (shoJoystick) {
      addJoyStick();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
     if (shoJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
        knob: SpriteComponent(
          sprite: Sprite(
            images.fromCache('HUD/Knob.png'),
          ),
        ),
        background: SpriteComponent(
          sprite: Sprite(
            images.fromCache('HUD/Joystick.png'),
          ),
        ),
        margin: const EdgeInsets.only(left: 9, bottom: 32));
    //Adding the component to the screen
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.right;
        break;
      default:
        //idle
        player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}
