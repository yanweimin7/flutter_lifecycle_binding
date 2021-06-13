import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_binding/flutter_lifecycle_binding.dart';

class StateWithMixinPage extends StatefulWidget {
  @override
  State<StateWithMixinPage> createState() {
    return _State();
  }
}

class _State extends State<StateWithMixinPage> with StateLifecycleBinding {
  String text = "如果5s内退出了页面，我不会被更新,也不会有日志打印";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 5000), () {
      return "我被更新了";
    }).bindLifecycleToState(this).then((value) {
      text = value;
      print(text);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Container(child: Text(text)));
  }
}
