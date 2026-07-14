import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArguments on BuildContext {
  T? getArgument<T>() {
    final modelRoute = ModalRoute.of(this);
    if (modelRoute != null) {
      final args = modelRoute.settings.arguments;
      if (args is T) {
        return args;
      }
    }
    return null;
  }
}
