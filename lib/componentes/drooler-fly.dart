import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutterappfly/componentes/fly.dart';
import 'package:flutterappfly/game_loop.dart';

class DroolerFly extends Fly{
  DroolerFly(GameLoop gameLoop, double x, double y): super(gameLoop){
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/drooler-fly-1.png"));
    flyingSprite.add(Sprite("flies/drooler-fly-2.png"));
    deadSprite = Sprite("flies/drooler-fly-dead.png");
  }
}