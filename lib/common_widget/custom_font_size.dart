import 'package:flutter/material.dart';

class CustomFontSize {
  /// 普通の文字
  static const smallFontSize = TextStyle(fontSize: 12);
  static const mediumFontSize = TextStyle(fontSize: 18);
  static const bigFontSize = TextStyle(fontSize: 24);

  /// Bold文字
  static const boldSmallFontSize =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
  static const boldMediumFontSize =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const boldBigFontSize =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
}
