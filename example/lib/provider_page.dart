import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_binding/flutter_lifecycle_binding.dart';
import 'package:provider/provider.dart';

class ProviderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class ViewModel with ChangeNotifier {
  BindingHelper _helper = BindingHelper();
  String _text = "如果5s内退出了页面，我不会被更新,也不会有日志打印";

  String get text => _text;

  ViewModel() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      return "我被更新了";
    }).bindLifecycle(_helper).then((value) {
      _text = value;
      print(_text);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _helper.dispose();
  }
}

class _State extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ChangeNotifierProvider<ViewModel>(
          create: (_) => ViewModel(),
          child: Consumer<ViewModel>(
            builder: (ctx, viewModel, child) {
              return Container(child: Text(viewModel.text));
            },
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
