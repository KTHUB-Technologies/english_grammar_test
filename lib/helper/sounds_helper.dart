import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';

class SoundsHelper{
  static final audioCache=AudioCache(prefix: 'assets/sounds/',fixedPlayer: audioPlayer);
  static AudioPlayer audioPlayer;

  static Future<void> load()async{
    audioCache.clearCache();
    List<String> listAssetSounds=[Sounds.touch,Sounds.in_correct,Sounds.correct];
    await audioCache.loadAll(listAssetSounds);
  }

  static Future<void> play(String audio) async{
    audioPlayer=await audioCache.play(audio,mode: PlayerMode.LOW_LATENCY);
  }

  static void stop(){
    audioPlayer.stop();
  }

  static void checkAudio(String audio) async{
    try{
      if(audioPlayer.state==AudioPlayerState.PLAYING)
        stop();
      else
        await play(audio);
    }catch(e){
      await play(audio);
    }
  }
}