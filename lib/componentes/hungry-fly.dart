import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterappfly/componentes/fly.dart';
import 'package:flutterappfly/game_loop.dart';

class HungryFly extends Fly{
  HungryFly(GameLoop gameLoop, double x, double y): super(gameLoop){
    flyRect = Rect.fromLTWH(x,y, gameLoop.tileSize * 1.1, gameLoop.tileSize * 1.65);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/hungry-fly-1.png"));
    flyingSprite.add(Sprite("flies/hungry-fly-2.png"));
    deadSprite = Sprite("flies/hungry-fly-dead.png");
  }
}