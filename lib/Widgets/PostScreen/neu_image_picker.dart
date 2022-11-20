import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'neu_button.dart';

class NeuImagePicker extends StatefulWidget {
  const NeuImagePicker({
    Key? key,
    required bool darkModeEnabled,
    required this.changePhoto,
  })  : _darkModeEnabled = darkModeEnabled,
        super(key: key);

  final bool _darkModeEnabled;
  final dynamic changePhoto;

  @override
  State<NeuImagePicker> createState() => _NeuImagePickerState();
}

class _NeuImagePickerState extends State<NeuImagePicker> {
  Future _captureVideo() async {
    try {
      final videoFile = await ImagePicker().pickVideo(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.rear,
          maxDuration: const Duration(seconds: 60));
      if (videoFile == null) return;
      final videoTemp = File(videoFile.path);
      widget.changePhoto(videoTemp);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed! Error ${e.details.toString()}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NeuButton(
              buttonLabel: "Open Camera",
              darkModeEnabled: widget._darkModeEnabled,
              performFunction: _captureVideo,
            ),
          ],
        ),
      ),
    );
  }
}
