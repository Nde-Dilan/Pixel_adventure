import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flame/game.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.setLandscape();

  Flame.device.fullScreen();

  PixelAdventure game = PixelAdventure();
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
}
