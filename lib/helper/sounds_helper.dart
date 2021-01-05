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
    // for(String audio in listAssetSounds){
    //   audioPlayer= await audioCache.play(audio,duckAudio: true, volume: 0, mode: PlayerMode.LOW_LATENCY);
    // }
  }

  static Future<void> play(String audio) async{
    audioPlayer=await audioCache.play(audio,mode: PlayerMode.LOW_LATENCY,duckAudio: true);
  }

  static void stop(){
    audioPlayer.stop();
  }

  static void checkAudio(String audio) async{
    try{
      if(audioPlayer.state==AudioPlayerState.PLAYING)
        stop();
      else
        play(audio);
    }catch(e){
      play(audio);
    }
  }
}