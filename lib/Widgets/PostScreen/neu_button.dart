import 'package:flutter/material.dart';

import '../../Global/global.dart';

class NeuButton extends StatefulWidget {
  const NeuButton({
    Key? key,
    required this.buttonLabel,
    required this.darkModeEnabled,
    required this.performFunction,
  }) : super(key: key);

  final bool darkModeEnabled;
  final String buttonLabel;
  final dynamic performFunction;

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(
          () {
            pressed = !pressed;
            widget.performFunction();
            Future.delayed(
              const Duration(milliseconds: 200),
            ).then((value) {
              if (mounted) {
                setState(() {
                  pressed = !pressed;
                });
              }
            });
          },
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          boxShadow: pressed
              ? []
              : widget.darkModeEnabled
                  ? GlobalTraits.neuShadowsDark
                  : GlobalTraits.neuShadows,
          color: widget.darkModeEnabled
              ? GlobalTraits.bgGlobalColorDark
              : GlobalTraits.bgGlobalColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            widget.buttonLabel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
