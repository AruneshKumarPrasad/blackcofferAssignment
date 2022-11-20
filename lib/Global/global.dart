import 'package:flutter/material.dart';

class GlobalTraits {
  static Color bgGlobalColor = const Color(0xffecf0f3);
  static Color bgGlobalColorDark = const Color(0xff292d32);
  static List<BoxShadow> neuShadows = const [
    BoxShadow(
      color: Colors.white,
      offset: Offset(-10.0, -10.0),
      blurRadius: 8.0,
    ),
    BoxShadow(
      color: Color(0xffd1d9e6),
      offset: Offset(10.0, 10.0),
      blurRadius: 8.0,
    ),
  ];
  static List<BoxShadow> neuShadowsDark = const [
    BoxShadow(
      color: Color(0xff30343a),
      offset: Offset(-10.0, -10.0),
      blurRadius: 8.0,
    ),
    BoxShadow(
      color: Color(0xff26262a),
      offset: Offset(10.0, 10.0),
      blurRadius: 8.0,
    ),
  ];
  static List<BoxShadow> neuShadowsCircular = const [
    BoxShadow(
      color: Colors.white,
      offset: Offset(-6.0, -6.0),
      blurRadius: 4.0,
    ),
    BoxShadow(
      color: Color(0xffd1d9e6),
      offset: Offset(6.0, 6.0),
      blurRadius: 4.0,
    ),
  ];
  static List<BoxShadow> neuShadowsCircularDark = const [
    BoxShadow(
      color: Color(0xff30343a),
      offset: Offset(-6.0, -6.0),
      blurRadius: 4.0,
    ),
    BoxShadow(
      color: Color(0xff1d1e21),
      offset: Offset(6.0, 6.0),
      blurRadius: 4.0,
    ),
  ];
  static InputDecoration textFieldDecoration = InputDecoration(
    isCollapsed: true,
    filled: true,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
}
