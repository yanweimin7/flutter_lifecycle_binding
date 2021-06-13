import 'core/binding_helper.dart';
import 'ex/state_lifecycle_binding.dart';

extension FutureEx on Future {
  Future<T> bindLifecycleToState<T>(StateLifecycleBinding state) {
    return state.bindLifecycle(this);
  }

  Future<T> bindLifecycle<T>(BindingHelper helper) {
    return helper.bindLifecycle(this);
  }
}
