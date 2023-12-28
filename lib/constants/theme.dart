import 'package:flutter/material.dart';

class ColorTheme {
  Color primary;
  Color background;

  ColorTheme({
    required this.primary,
    required this.background,
  });
}

final purpleTheme = ColorTheme(
  primary: const Color(0xFF503a65),
  background: const Color(0xFFfbf7ff),
);
