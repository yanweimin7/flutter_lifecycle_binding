import 'package:flutter/material.dart';
import 'package:lifecycle_binding/lifecycle_binding.dart';

class AsyncFuturePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State with StateLifecycleBinding {
  String text = "请观察flutter 日志";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 5000), () {
      return "如果5s内退出了页面，我不会被打印";
    }).then((value) {
      print(value);
      setState(() {});
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      return "如果3s内退出了页面，我不会被打印";
    }).bindLifecycle(this).then((value) {
      print(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Container(child: Text(text)));
  }
}
