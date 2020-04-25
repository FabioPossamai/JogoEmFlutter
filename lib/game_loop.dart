import 'dart:math';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterappfly/componentes/agile-fly.dart';
import 'package:flutterappfly/componentes/backyard.dart';
import 'package:flutterappfly/componentes/credits-button.dart';
import 'package:flutterappfly/componentes/drooler-fly.dart';
import 'package:flutterappfly/componentes/fly.dart';
import 'package:flutterappfly/componentes/help-button.dart';
import 'package:flutterappfly/componentes/highscore-display.dart';
import 'package:flutterappfly/componentes/house-fly.dart';
import 'package:flutterappfly/componentes/hungry-fly.dart';
import 'package:flutterappfly/componentes/macho-fly.dart';
import 'package:flutterappfly/componentes/music-button.dart';
import 'package:flutterappfly/componentes/score-display.dart';
import 'package:flutterappfly/componentes/sound-button.dart';
import 'package:flutterappfly/componentes/start-button.dart';
import 'package:flutterappfly/view.dart';
import 'package:flutterappfly/view/credits-view.dart';
import 'package:flutterappfly/view/help-view.dart';
import 'package:flutterappfly/view/home-view.dart';
import 'package:flutterappfly/view/lost-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/spawner.dart';
import 'package:audioplayers/audioplayers.dart';
//import 'package:langaw/components/music-button.dart';
//import 'package:langaw/components/sound-button.dart';
class GameLoop extends Game {
  View activeView = View.home;
  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;

  HomeView homeView;
  LostView lostView;
  HelpView helpView;
  CreditsView creditsView;

  Backyard backyard;

  StartButton startButton;
  HelpButton helpButton;
  CreditsButton creditsButton;
  MusicButton musicButton;
  SoundButton soundButton;
  ScoreDisplay scoreDisplay;


  FlySpawner spawner;

  int score;
  HighscoreDisplay highscoreDisplay;

  final SharedPreferences storage;

  AudioPlayer homeBGM;
  AudioPlayer playingBGM;



  GameLoop(this.storage){
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    score = 0;
    spawner = FlySpawner(this);
    homeView = HomeView(this);
    lostView = LostView(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);

    backyard = Backyard(this);

    startButton = StartButton(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    musicButton = MusicButton(this);
    soundButton = SoundButton(this);
    scoreDisplay = ScoreDisplay(this);

    highscoreDisplay = HighscoreDisplay(this);

    homeBGM = await Flame.audio.loopLongAudio('bgm/home.mp3', volume: .25);
    homeBGM.pause();
    playingBGM = await Flame.audio.loopLongAudio('bgm/playing.mp3', volume: .25);
    playingBGM.pause();

    playHomeBGM();
  }
  void playHomeBGM() {
    playingBGM.pause();
    playingBGM.seek(Duration.zero);
    homeBGM.resume();
  }

  void playPlayingBGM() {
    homeBGM.pause();
    homeBGM.seek(Duration.zero);
    playingBGM.resume();
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 1.35));
    double y = (rnd.nextDouble() * (screenSize.height - (tileSize * 2.85))) + (tileSize * 1.5);

    switch(rnd.nextInt(5)){
      case 0:
        flies.add(AgileFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(HouseFly(this, x, y));
        break;
      case 3:
        flies.add(HungryFly(this, x, y));
        break;
      case 4:
        flies.add(MachoFly(this, x, y));
        break;
    }
  }

  void render(Canvas canvas) {

    backyard.render(canvas);

    if (activeView == View.playing) scoreDisplay.render(canvas);

    flies.forEach((fly) {
      fly.render(canvas);
    });

    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }

    if(activeView != View.help && activeView != View.credits) {
      musicButton.render(canvas);
      soundButton.render(canvas);
      highscoreDisplay.render(canvas);
    }
    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);
  }

  void update(double t){
    spawner.update(t);

    flies.forEach((fly) {
      fly.update(t);
    });

    flies.removeWhere((fly) => fly.isOffScreen);

    if (activeView == View.playing) scoreDisplay.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails details) {
    // start button
    if (startButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        return;
      }
    }

    //dialog views
    if (activeView == View.help || activeView == View.credits) {
      activeView = View.home;
      return;
    }

    // help button
    if (helpButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        return;
      }
    }

    // credits button
    if (creditsButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        return;
      }
    }

    bool didHitAFly = false;
    List<Fly>.from(flies).forEach((fly) {
      if (fly.flyRect.contains(details.globalPosition) && !fly.isDead){
        fly.onTapDown();
        didHitAFly = true;
        return;
      }
    });
    // music button
    if (musicButton.rect.contains(details.globalPosition)) {
      musicButton.onTapDown();
      return;
    }
    // sound button
    if (soundButton.rect.contains(details.globalPosition)) {
      soundButton.onTapDown();
      return;
    }
    if (activeView == View.playing && !didHitAFly) {
      if (soundButton.isEnabled) {
        Flame.audio.play('sfx/haha${(rnd.nextInt(5) + 1).toString()}.ogg');
      }
      activeView = View.lost;
      playHomeBGM();
    }
  }
}