
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';

class SoundsHelper {
  static final AppController appController=Get.find();
  static final audioCache =
      AudioCache(prefix: 'assets/sounds/',fixedPlayer: audioPlayer);
  static AudioPlayer audioPlayer;

  static Future<void> load() async {
    List<String> listAssetSounds = [
      Sounds.touch,
      Sounds.in_correct,
      Sounds.correct
    ];
    await audioCache.loadAll(listAssetSounds);
  }

  static Future<void> play(String audio) async {
    audioPlayer = await audioCache.play(audio,
        mode: PlayerMode.LOW_LATENCY, duckAudio: true);
  }

  static void stop() {
    audioPlayer.stop();
  }

  static void checkAudio(String audio) async {
    if(appController.sound.value==true){
      try {
        if(Platform.isIOS){
          if (audioPlayer.state == AudioPlayerState.PLAYING)
            stop();
          else
            play(audio);
        }else if(Platform.isAndroid)
          play(audio);
      } catch (e) {
        play(audio);
      }
    }
  }
}
