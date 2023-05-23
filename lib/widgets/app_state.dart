import 'package:flutter/widgets.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class AppState with WidgetsBindingObserver {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  final bool Function() getSound;

  late bool _soundEnabled;

  AppState({
    Key? key,
    required this.getSound,
  });

  void initialize() {
    audioPlayer.open(
      Audio('assets/audios/music.mp3'),
      loopMode: LoopMode.single,
    );

    _soundEnabled = getSound();
    WidgetsBinding.instance.addObserver(this);
  }

  void updateSoundState(bool soundState) {
    _soundEnabled = soundState;

    if (_soundEnabled) {
      audioPlayer.play();
    } else {
      audioPlayer.pause();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _soundEnabled = getSound();

    if (_soundEnabled) {
      if (state == AppLifecycleState.resumed) {
        audioPlayer.play();
      } else if (state == AppLifecycleState.paused) {
        audioPlayer.pause();
      }
    }
  }

  void dispose() {
    audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
