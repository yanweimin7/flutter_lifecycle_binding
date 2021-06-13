import 'dart:async';

class CancellableCompleter<T> {
  bool _isCancel = false;

  set isCancel(bool value) {
    _isCancel = value;
  }

  Completer<T> completer = Completer();

  void complete([FutureOr<T>? value]) {
    if (!_isCancel) completer.complete(value);
  }

  void completeError(Object error, [StackTrace? stackTrace]) {
    if (!_isCancel) completer.completeError(error, stackTrace);
  }

  Future<T> get future {
    return completer.future;
  }
}
