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
