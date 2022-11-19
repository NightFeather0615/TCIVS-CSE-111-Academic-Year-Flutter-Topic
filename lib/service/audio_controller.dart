import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SongData {
  final String title;
  final String author;
  final String audioSource;
  final String coverSource;
  final int duration;

  const SongData({
    required this.title,
    required this.author,
    required this.audioSource,
    required this.coverSource,
    required this.duration,
  });

  factory SongData.fromJson(Map<String, dynamic> json) {
    return SongData(
      title: json["title"],
      author: json["author"],
      audioSource: json["audio_source"],
      coverSource: json["cover_source"],
      duration: json["duration"],
    );
  }
}

class AudioController {
  AudioController._();

  static AudioController? _instance;
  static AudioPlayer? _audioPlayer;

  static AudioController get instance {
    if (_instance == null) {
      _audioPlayer = AudioPlayer();
      _audioPlayer!.setVolume(0.35);

      _instance = AudioController._();

      _audioPlayer!.onPlayerComplete.listen((event) async {
        if (_instance!.currentQueueIsLooping) {
          await _instance!.play(_instance!.currentPlayingSongIndex.value);
        } else {
          await _instance!.play((_instance!.currentPlayingSongIndex.value + 1) % _instance!._songQueue.length);
        }
      });
      _audioPlayer!.onPositionChanged.listen((event) {
        _instance!._currentPlayingSongProgress.value = event.inSeconds;
      });
    }
    return _instance!;
  }

  static String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  List<SongData> _songData = [];
  List<SongData> _songQueue = [];
  final ValueNotifier<int> _currentPlayingSongIndex = ValueNotifier<int>(0);
  String _currentPlayingSongCoverSource = "";
  String _currentPlayingSongTitle = "N/A";
  String _currentPlayingSongAuthor = "N/A";
  int _currentPlayingSongDuration = 1;
  final ValueNotifier<int> _currentPlayingSongProgress = ValueNotifier<int>(0);
  final ValueNotifier<bool> _currentSongIsPlaying = ValueNotifier<bool>(false);
  bool currentQueueIsLooping = false;
  bool _currentQueueIsShuffle = false;

  Future setSongQueue(List<SongData> newQueue) async {
    _songQueue = newQueue;
    _currentPlayingSongCoverSource = _songQueue[_currentPlayingSongIndex.value].coverSource;
    _currentPlayingSongTitle = _songQueue[_currentPlayingSongIndex.value].title;
    _currentPlayingSongAuthor = _songQueue[_currentPlayingSongIndex.value].author;
    _currentPlayingSongDuration = _songQueue[_currentPlayingSongIndex.value].duration;
    await _audioPlayer!.setSource(UrlSource(_songQueue[_currentPlayingSongIndex.value].audioSource));
    await _instance!.pause();
  }

  List<SongData> get songQueue {
    return _songQueue;
  }

  ValueNotifier<int> get currentPlayingSongIndex {
    return _currentPlayingSongIndex;
  }

  String get currentPlayingSongCoverSource {
    return _currentPlayingSongCoverSource;
  }

  String get currentPlayingSongTitle {
    return _currentPlayingSongTitle;
  }

  String get currentPlayingSongAuthor {
    return _currentPlayingSongAuthor;
  }

  int get currentPlayingSongDuration {
    return _currentPlayingSongDuration;
  }

  ValueNotifier<int> get currentPlayingSongProgress {
    return _currentPlayingSongProgress;
  }

  ValueNotifier<bool> get currentSongIsPlaying {
    return _currentSongIsPlaying;
  }

  Future play(int index) async {
    _currentPlayingSongProgress.value = 0;
    _currentPlayingSongIndex.value = index;
    _currentPlayingSongCoverSource =  _songQueue[index].coverSource;
    _currentPlayingSongTitle = _songQueue[index].title;
    _currentPlayingSongAuthor = _songQueue[index].author;
    _currentPlayingSongDuration = _songQueue[index].duration;
    _currentSongIsPlaying.value = true;

    await _audioPlayer!.play(UrlSource(_songQueue[index].audioSource));
  }

  Future stop() async {
    _currentSongIsPlaying.value = false;
    _currentPlayingSongIndex.value = -1;

    await _audioPlayer!.stop();
  }

  Future pause() async {
    _currentSongIsPlaying.value = false;

    await _audioPlayer!.pause();
  }

  Future resume() async {
    _currentSongIsPlaying.value = true;

    await _audioPlayer!.resume();
  }

  Future seekTo(int second) async {
    _currentPlayingSongProgress.value = second;

    await _audioPlayer!.seek(Duration(seconds: second));
  }
}
