import 'dart:io';

import 'package:flutter/material.dart';

import '../../Global/global.dart';
import 'neu_image_picker.dart';

class UploadVideo extends StatelessWidget {
  const UploadVideo({
    Key? key,
    required bool darkModeEnabled,
    required File? image,
    required this.changePhoto,
  })  : _darkModeEnabled = darkModeEnabled,
        _image = image,
        super(key: key);

  final bool _darkModeEnabled;
  final dynamic changePhoto;
  final File? _image;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 100,
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: _darkModeEnabled
            ? GlobalTraits.neuShadowsDark
            : GlobalTraits.neuShadows,
        color: _darkModeEnabled
            ? GlobalTraits.bgGlobalColorDark
            : GlobalTraits.bgGlobalColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: _image == null
                ? const Icon(Icons.photo)
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  backgroundColor: _darkModeEnabled
                      ? GlobalTraits.bgGlobalColorDark
                      : GlobalTraits.bgGlobalColor,
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (BuildContext context,
                        StateSetter setState /*You can rename this!*/) {
                      return NeuImagePicker(
                        darkModeEnabled: _darkModeEnabled,
                        changePhoto: changePhoto,
                      );
                    });
                  },
                );
              },
              child: AnimatedContainer(
                duration: const Duration(microseconds: 200),
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    color: _darkModeEnabled
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child: const Icon(
                  Icons.edit,
                  size: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
