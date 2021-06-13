import 'package:flutter/material.dart';
import 'package:lifecycle_binding_example/state_page.dart';

import 'provider_page.dart';
import 'state_with_mixin_page.dart';

main() {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (ctx) {
          return Container(
            child: Column(
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.push(ctx, MaterialPageRoute(builder: (_) {
                      return StatePage();
                    }));
                  },
                  child: Text("使用 BindingHelper"),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(ctx, MaterialPageRoute(builder: (_) {
                      return StateWithMixinPage();
                    }));
                  },
                  child: Text("使用 mixin StateLifecycleBinding"),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(ctx, MaterialPageRoute(builder: (_) {
                      return ProviderPage();
                    }));
                  },
                  child: Text("在provider中使用"),
                )
              ],
            ),
          );
        },
      ),
    ));
  }
}
