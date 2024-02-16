import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState {
  idle,
  running,
}

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  String character;
  Player({
    position,
    required this.character,
  }) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimatiion;
  final double _stepTime = 0.05;
  final int amount = 11;

  //Player direction
  PlayerDirection playerDirection = PlayerDirection.left;

  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  bool isFacingRight = true;

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    //Loads All the animations
    _onAnimationsLoaded();
    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    print(keysPressed);
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
      print('Going left');
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
      print('Going right');
    } else {
      playerDirection = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _onAnimationsLoaded() {
    idleAnimation = _createAnimation("Idle", 11);
    runningAnimatiion = _createAnimation("Run", 12);

    //List of all registered animations, when u create one just add it here
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimatiion,
    };

    //Set the current animation
    current = PlayerState.running;
  }

  SpriteAnimation _createAnimation(String name, int amount) {
    SpriteAnimation animationtype = SpriteAnimation.fromFrameData(
        //Fetching animation from cache and creating a sequence of animation with a step time , the number of sprite in the image(amount) and the textureSize
        game.images.fromCache("Main Characters/$character/$name (32x32).png"),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: _stepTime, textureSize: Vector2.all(32)));
    return animationtype;
  }

  void _updatePlayerMovement(double dt) {
    double directionX = 0.0;

    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        directionX -= moveSpeed;
        current = PlayerState.running;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        directionX += moveSpeed;
        current = PlayerState.running;
        break;
      case PlayerDirection.none:
        directionX = directionX;
        break;
      default:
    }
    //We need a vector2 to add it to the position of our player and hence update its location
    velocity = Vector2(directionX, 0.0);
    //When adding just the velocity to the position, the game will be really fast and we won't be able to see something on the screen because the delta time is too short (reason why we can reduce the speed by * dt to our velocity)
    // print(dt);
    position += velocity * dt;
  }
}
