import 'state_lifecycle_binding.dart';

extension FutureEx on Future {
  Future<T> bindLifecycle<T>(StateLifecycleBinding state) {
    return state.bindLifecycle(this);
  }
}
