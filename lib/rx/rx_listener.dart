import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class RxListener {
  late final VoidCallback onPressed;
  final PublishSubject<bool> _subject = PublishSubject();

  Stream<bool> get rxOnPressed => _subject;

  RxListener() {
    onPressed = () {
      _subject.add(true);
    };
  }
}

class RxValueChanged<T> {
  late final ValueChanged<T> onLoad;
  final PublishSubject<T> _subject = PublishSubject();

  Stream<T> get didChange => _subject;

  RxValueChanged() {
    onLoad = (value) {
      _subject.add(value);
    };
  }
}
