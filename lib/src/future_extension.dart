import 'core/binding_helper.dart';
import 'ex/state_lifecycle_binding.dart';

extension FutureEx on Future {
  Future bindLifecycleToState(StateLifecycleBinding state) {
    return state.bindLifecycle(this);
  }

  Future bindLifecycle(BindingHelper helper) {
    return helper.bindLifecycle(this);
  }
}
