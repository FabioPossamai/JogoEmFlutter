import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterappfly/componentes/fly.dart';
import 'package:flutterappfly/game_loop.dart';

class HouseFly extends Fly{
  HouseFly(GameLoop gameLoop, double x, double y): super(gameLoop){
    flyRect = Rect.fromLTWH(x,y, gameLoop.tileSize, gameLoop.tileSize * 1.5);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/house-fly-1.png"));
    flyingSprite.add(Sprite("flies/house-fly-2.png"));
    deadSprite = Sprite("flies/house-fly-dead.png");
  }
}