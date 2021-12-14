import 'package:flutter/material.dart';

class AudioPlayerModel with ChangeNotifier{
  bool _playing = false;
  AnimationController _controller;
  Duration _songDuration = new Duration(milliseconds: 0);
  Duration _current = new Duration(milliseconds: 0);



  String get songTotalDuration => this.printDuration(_songDuration);
  String get currentSecond => this.printDuration(_current);

  double get getPorcentaje => (this._songDuration.inSeconds > 0) ? this._current.inSeconds / this._songDuration.inSeconds : 0;

  set controller(AnimationController valor) {
    this._controller = valor;
  }
  AnimationController get controller => this._controller;


  set playing(bool valor){
    this._playing = valor;
    notifyListeners();
  }
  bool get playing => this._playing;

  Duration get songDuration => this._songDuration;
  set songDuration(Duration valor){
    this._songDuration = valor;
    notifyListeners();

  }
  Duration get current => this._current;
  set current(Duration valor){
    this._current = valor;
    notifyListeners();
  }

  String printDuration(Duration duration) {
    String twodigits(int n) {
      if(n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twodigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twodigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}