import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // playlist of the songs

  final List<Song> _playlist = [
    // song 1
    Song(
      songName: "Let's enjoy this days",
      artistName: "Linguasonix",
      albumArtImagePath: "assets/images/let's-enjoy-this-day.jpg",
      audioPath: "audio/Let's Enjoy This Day.mp3",
    ),

    // song 2
    Song(
      songName: "Unstoppable",
      artistName: "Sia",
      albumArtImagePath: "assets/images/unstoppable-song-song.webp",
      audioPath: "audio/unstoppable.mp3",
    ),
  ];

  // current song playing index

  int? _currentSongIndex;

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  // audio player
  // duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  // constructor
  PlaylistProvider() {
    listenToDuration();
  }
  // initially not playing
  bool _isPlaying = false;
  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop current song
    await _audioPlayer.play(AssetSource(path)); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause the current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing the song()
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }

  // play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // go to the next song if it's not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        // if it's the laast song, loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() async {
    // if more than 2 secs passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    // if it's with in first 2 sec's of the song, go to previous song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // list to duration
  void listenToDuration() {
    // listen for the total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    // listen for the current duration
    _audioPlayer.onPositionChanged.listen((newDuration) {
      _currentDuration = newDuration;
      notifyListeners();
    });
    // listen for the song completation
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }
  // dispose audio player

  // getters

  List<Song> get playlist => _playlist;

  int? get currentSongIndex => _currentSongIndex;

  bool get isPlaying => _isPlaying;

  Duration get currentDuration => _currentDuration;

  Duration get totalDuration => _totalDuration;

  // setters
  set currentSongIndex(int? newIndex) {
    // update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // play the song at new index
    }

    // update UI
    notifyListeners();
  }
}
