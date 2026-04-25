import 'package:just_audio/just_audio.dart';

class AudioService {
  static final _player = AudioPlayer();

  static Future<void> play(String id) async {
    await _player.setAsset('assets/audio/$id.mp3');
    await _player.setLoopMode(LoopMode.one);
    _player.play();
  }

  static Future<void> stop() => _player.stop();
}
