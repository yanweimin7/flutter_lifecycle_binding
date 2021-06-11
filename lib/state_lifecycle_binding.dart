import 'dart:async';

import 'package:flutter/material.dart';

import 'cancellable_completer.dart';

mixin StateLifecycleBinding on State {
  List<CancellableCompleter> _completerList = [];

  Future<T> bindLifecycle<T>(Future<T> future) {
    CancellableCompleter<T> completer = CancellableCompleter();

    future.then((value) {
      completer.complete(value);
    }).catchError((Object error, StackTrace stackTrace) {
      completer.completeError(error, stackTrace);
    });

    _completerList.add(completer);
    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
    _completerList.forEach((element) {
      element.isCancel = true;
    });
    _completerList.clear();
  }
}
