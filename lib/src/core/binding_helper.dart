import 'cancellable_completer.dart';

class BindingHelper {
  List<CancellableCompleter> _completerList = [];

  Future<T> bindLifecycle<T>(Future<T> future) {
    CancellableCompleter<T> completer = CancellableCompleter();

    future.then((value) {
      completer.complete(value);
      _completerList.remove(completer);
    }).catchError((Object error, StackTrace stackTrace) {
      completer.completeError(error, stackTrace);
      _completerList.remove(completer);
    });

    _completerList.add(completer);
    return completer.future;
  }

  void dispose() {
    _completerList.forEach((element) {
      element.isCancel = true;
    });
    _completerList.clear();
  }
}
