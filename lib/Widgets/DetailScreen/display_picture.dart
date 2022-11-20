import 'package:flutter/material.dart';

import '../../Global/global.dart';

class DisplayPicture extends StatelessWidget {
  const DisplayPicture({
    Key? key,
    required this.darkModeEnabled,
    required this.profile,
  }) : super(key: key);

  final bool darkModeEnabled;
  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: 280,
        width: double.infinity,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          boxShadow: darkModeEnabled
              ? GlobalTraits.neuShadowsDark
              : GlobalTraits.neuShadows,
          color: darkModeEnabled
              ? GlobalTraits.bgGlobalColorDark
              : GlobalTraits.bgGlobalColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                boxShadow: darkModeEnabled
                    ? GlobalTraits.neuShadowsDark
                    : GlobalTraits.neuShadows,
                color: darkModeEnabled
                    ? GlobalTraits.bgGlobalColorDark
                    : GlobalTraits.bgGlobalColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  profile["ThumbURL"],
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile["Name"],
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    profile["Category"],
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
