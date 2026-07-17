import 'package:flutter/material.dart';

typedef CloseLoadingScreean = bool Function();

typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreean close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({required this.close, required this.update});
}
