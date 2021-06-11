import 'package:flutter/material.dart';

import 'async_future_page.dart';

main() {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (ctx){
        return Container(
          child: Column(
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(ctx, MaterialPageRoute(builder: (_) {
                    return AsyncFuturePage();
                  }));
                },
                child: Text("测试异步future"),
              )
            ],
          ),
        );
      },),
    ));
  }
}
