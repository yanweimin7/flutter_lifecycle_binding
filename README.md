[chinese readme](./README_CN.md)

### Aim
bind future to State ,when state disposed ,all binded future will cancelled;

### Usage:

1. add mixin on State

   ```dart
   import 'package:lifecycle_binding/lifecycle_binding.dart';
   
   class _State extends State with StateLifecycleBinding
   
   ```

2. bind future to State

```dart
future.bindLifecycle(state).then((){...})
```


### Attention
1.when use future like this:

```dart
  future.then((){
    //section 1
   })
  bindLifecycle(state)
  .then((){
    //section 2
   })
```

section 1 will always run,  section 2 will not run when state has disposed , so you should put ui releated code in section 2;
but

### Full Example

```dart
import 'package:flutter/material.dart';
import 'package:lifecycle_binding/lifecycle_binding.dart';

class AsyncFuturePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State with StateLifecycleBinding {
  String text = "please read flutter log";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 5000), () {
      return "if this page disposed in 5 seconds ,i will not print";
    }).then((value) {
      print(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Container(child: Text(text)));
  }
}

```