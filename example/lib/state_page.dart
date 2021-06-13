import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_binding/flutter_lifecycle_binding.dart';

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
