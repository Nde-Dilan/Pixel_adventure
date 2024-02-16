import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/levels/level.dart';


//tell Flame to listen to keyBoard events
class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  //The world where our map is found
  final myWorld = Level(levelName: "Level-02");

  @override
  FutureOr<void> onLoad() async {

    //Adding images to cache
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
        world: myWorld, width: 640, height: 360);


    //Change the starting point of the camera 
    cam.viewfinder.anchor = Anchor.topLeft;

    

    // print("Loading....");

    addAll([cam, myWorld]);
    return super.onLoad();
  }
}
