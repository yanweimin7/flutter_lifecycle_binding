[中文版文档](./README_CN.md)

### Aim
bind future to State ,when state disposed ,all binded future will cancelled;

### Usage:
1. create BindingHelper instance

```dart
BindingHelper _helper = BindingHelper();
```

2. bind future to BindingHelper

```dart
 future.bindLifecycle(_helper).then((...))
```

3. dispose BindingHelper when ui disposed (for example: state disposed)
```dart 
  @override
  void dispose() {
    super.dispose();
    _helper.dispose();
  }
```

if you want use in State ,there is another mixin you can use.
1. add mixin on State

   ```dart
   import 'package:lifecycle_binding/lifecycle_binding.dart';
   
   class _State extends State with StateLifecycleBinding
   
   ```

2. bind future to State

```dart
future.bindLifecycleToState(this).then((){...})
```


### Attention
1.when use future like this:

```dart
  future.then((){
    //section 1
   })
  bindLifecycle(helper)
  .then((){
    //section 2
   })
```

section 1 will always run,  section 2 will not run when state has disposed , so you should put ui releated code in section 2;
but

### Full Example

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
