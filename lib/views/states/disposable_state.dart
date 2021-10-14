import 'package:flutter/cupertino.dart';
import 'package:musicapp/rx/dispose_bag.dart';

abstract class DisposableState<T extends StatefulWidget> extends State<T> {
  late DisposeBag bag;

  @override
  void initState() {
    super.initState();
    bag = DisposeBag();
  }

  @override
  void dispose() {
    bag.dispose();
    super.dispose();
  }
}
