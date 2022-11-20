import 'package:flutter/material.dart';

class DescriptionDiv extends StatelessWidget {
  const DescriptionDiv({
    Key? key,
    required this.label,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: Colors.black,
                thickness: 0.8,
              ),
            ),
            Text(
              "   ${label}   ",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Expanded(
              child: Divider(
                color: Colors.black,
                thickness: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
