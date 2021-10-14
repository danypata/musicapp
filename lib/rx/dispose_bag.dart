import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

mixin Disposable {
  void dispose();
}

class DisposeBag {
  final List<StreamSubscription> _subscriptions = [];
  final List<AnimationController> _controllers = [];
  final List<StreamController> _streams = [];
  final List<Disposable> _disposables = [];

  void disposeLater(Object object) {
    if (object is StreamSubscription) {
      _subscriptions.add(object);
    } else if (object is AnimationController) {
      _controllers.add(object);
    } else if (object is StreamController) {
      _streams.add(object);
    } else if (object is Disposable) {
      _disposables.add(object);
    }
  }

  void dispose() {
    try {
      _subscriptions.forEach((element) {
        element.cancel().then((value) => {}, onError: (err, stack) {
          debugPrint("CANCLE ERROR: ${err} == ${stack.toString()}");
        });
      });
    } on PlatformException {
    } on Exception {}
    try {
      _controllers.forEach((element) => element.dispose());
    } on PlatformException {
    } on Exception {}
    try {
      _streams.forEach((element) => element.close());
    } on PlatformException {
    } on Exception {}
    try {
      _disposables.forEach((element) => element.dispose());
    } on PlatformException {
    } on Exception {}

    _subscriptions.clear();
    _controllers.clear();
    _streams.clear();
    _disposables.clear();
  }

  void print() {
    debugPrint("Subs: ${_subscriptions.length}\n"
        "Controller: ${_controllers.length}\n"
        "Streams: ${_streams.length}\n"
        "Disposables: ${_disposables.length}");
  }
}

extension DisposableSubscription on StreamSubscription {
  void disposeBy(DisposeBag bag) {
    this.onDone(() {
      bag._subscriptions.removeWhere((element) => element == this);
    });
    bag.disposeLater(this);
  }
}

extension DisposableControllers<T> on StreamController<T> {
  void disposeBy(DisposeBag bag) {
    bag.disposeLater(this);
  }
}

extension DisposableAnimationControllers on AnimationController {
  void disposeBy(DisposeBag bag) {
    bag.disposeLater(this);
  }
}

extension Nullables<T> on Stream<T> {
  Stream<T> filterNotNull() {
    return this.where((event) => event != null);
  }
}
