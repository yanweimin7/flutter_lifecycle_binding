
### 背景

flutter 目前没有类似android 的lifecycle & livedata机制，在界面销毁后，异步回调更新ui会报错 ， 如在state中发起一个延迟5s的任务，5s内退出页面

```
    Future.delayed(const Duration(milliseconds: 5000), () {
    }).then((value) {
      setState(() {});
    });
```

5s后会报如下错误，

```
E/flutter (19147): [ERROR:flutter/lib/ui/ui_dart_state.cc(177)] Unhandled Exception: setState() called after dispose(): _State#7541f(lifecycle state: defunct, not mounted)
E/flutter (19147): This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
E/flutter (19147): The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
E/flutter (19147): This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
E/flutter (19147): #0      State.setState.<anonymous closure> (package:flutter/src/widgets/framework.dart:1208:9)
E/flutter (19147): #1      State.setState (package:flutter/src/widgets/framework.dart:1243:6)
E/flutter (19147): #2      _State.initState.<anonymous closure> (package:lifecycle_binding_example/async_future_page.dart:21:7)
E/flutter (19147): #3      _rootRunUnary (dart:async/zone.dart:1198:47)
E/flutter (19147): #4      _CustomZone.runUnary (dart:async/zone.dart:1100:19)
E/flutter (19147): #5      _FutureListener.handleValue (dart:async/future_impl.dart:143:18)
E/flutter (19147): #6      Future._propagateToListeners.handleValueCallback (dart:async/future_impl.dart:696:45)
E/flutter (19147): #7      Future._propagateToListeners (dart:async/future_impl.dart:725:32)
E/flutter (19147): #8      Future._complete (dart:async/future_impl.dart:519:7)
E/flutter (19147): #9      new Future.delayed.<anonymous closure> (dart:async/future.dart:326:18)
E/flutter (19147): #10     _rootRun (dart:async/zone.dart:1182:47)
E/flutter (19147): #11     _CustomZone.run (dart:async/zone.dart:1093:19)
E/flutter (19147): #12     _CustomZone.runGuarded (dart:async/zone.dart:997:7)
E/flutter (19147): #13     _CustomZone.bindCallbackGuarded.<anonymous closure> (dart:async/zone.dart:1037:23)
E/flutter (19147): #14     _rootRun (dart:async/zone.dart:1190:13)
E/flutter (19147): #15     _CustomZone.run (dart:async/zone.dart:1093:19)
E/flutter (19147): #16     _CustomZone.bindCallback.<anonymous closure> (dart:async/zone.dart:1021:23)
E/flutter (19147): #17     Timer._createTimer.<anonymous closure> (dart:async-patch/timer_patch.dart:18:15)
E/flutter (19147): #18     _Timer._runTimers (dart:isolate-patch/timer_impl.dart:397:19)
E/flutter (19147): #19     _Timer._handleMessage (dart:isolate-patch/timer_impl.dart:428:5)
E/flutter (19147): #20     _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:168:12)
```
原因在于调用setState时，widget & state 已经销毁，不能再更新.
以上只是举一个很简单的例子，事实上在真实业务开发中，我们经常会碰到异步回调跟ui生命周期不同步导致各种异常报错的问题，(如网络请求，method channel调用等)。因此希望有一种方式能够将future 跟 state的生命周期做同步，在state dispose后，future不会再被执行，这样就能做到与ui的同步。


### 使用方法:

1. 创建 BindingHelper对象
```dart
BindingHelper _helper = BindingHelper();

```
2. 将future绑定到helper对象上:

```dart
 future.bindLifecycle(_helper).then((...))
```

3. 销毁helper对象，比如在State dispose时:
```dart 
  @override
  void dispose() {
    super.dispose();
    _helper.dispose();
  }
```

1. 如果你想在state中直接使用该功能，可以直接使用StateLifecycleBinding

   ```dart
   import 'package:lifecycle_binding/lifecycle_binding.dart';
   class _State extends State with StateLifecycleBinding
   ```

2. 将future与state绑定

```dart
future.bindLifecycleToState(state).then((){...})
```

这样关系就绑定好了，不用再helper对象的创建和销毁。


### 注意点
1. 如future使用方式如下 

```dart
  future.then((){
    //section 1
   })
  bindLifecycle(helper)
  .then((){
    //section 2
   })
```
section 1 是一定会执行的，section 2 则根据state是否已经dispose确定是否调用，也就是说 bindLifecycle 只对它之后的then生效，它之前的then是一定会调用的，如果涉及到更新ui的操作，一定要放到bindLifecycle之后。

### 完整示例

```dart

import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_binding/lifecycle_binding.dart';

class StatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State {
  String text = "如果5s内退出了页面，我不会被更新,也不会有日志打印";

  BindingHelper _helper = BindingHelper();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 5000), () {
      return "我被更新了";
    }).bindLifecycle(_helper).then((value) {
      text = value;
      print(text);
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Container(child: Text(text)));
  }

  @override
  void dispose() {
    super.dispose();
    _helper.dispose();
  }
}

```
