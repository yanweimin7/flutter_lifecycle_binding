import 'dart:async';

import 'package:flutter/material.dart';

import '../core/binding_helper.dart';

mixin StateLifecycleBinding<T extends StatefulWidget> on State<T> {
  BindingHelper _helper = BindingHelper();

  Future<T> bindLifecycle<T>(Future<T> future) {
    return _helper.bindLifecycle(future);
  }

  @override
  void dispose() {
    _helper.dispose();
    super.dispose();
  }
}
