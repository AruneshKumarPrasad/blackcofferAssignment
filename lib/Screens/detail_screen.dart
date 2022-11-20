import 'package:flutter/material.dart';

import '../Global/global.dart';
import '../Widgets/DetailScreen/description_divider.dart';
import '../Widgets/DetailScreen/display_app_bar.dart';
import '../Widgets/DetailScreen/video_player.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    Key? key,
    required this.darkModeEnabled,
    required this.profile,
  }) : super(key: key);

  final bool darkModeEnabled;
  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: DisplayAppBar(darkModeEnabled: darkModeEnabled),
      ),
      body: AnimatedContainer(
          height: double.infinity,
          width: double.infinity,
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 25,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VideoPlayerDetail(
                  darkModeEnabled: darkModeEnabled, profile: profile),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Genre: ${profile["Category"]}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const DescriptionDiv(
                      label: "Description",
                    ),
                    Text(
                      "${profile["Description"]}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const DescriptionDiv(
                      label: "Location",
                    ),
                    Text(
                      "Latitude / Longitude :  ${profile["Location"]}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
