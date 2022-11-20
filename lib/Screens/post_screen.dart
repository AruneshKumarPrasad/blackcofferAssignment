import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Global/global.dart';
import '../Helpers/firebase.dart';
import '../Helpers/models.dart';
import '../Widgets/PostScreen/drop_down_field.dart';
import '../Widgets/PostScreen/neu_button.dart';
import '../Widgets/PostScreen/neu_text_field.dart';
import '../Widgets/PostScreen/photo_upload.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    Key? key,
    required bool darkModeEnabled,
    required this.uid,
  })  : _darkModeEnabled = darkModeEnabled,
        super(key: key);

  final bool _darkModeEnabled;
  final String uid;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  String _dropDownValue = "Vlog";
  bool _isLoading = false;
  File? _thumbnail;
  File? _videoFile;

  final Model _profile = Model(
    profileID: '',
    videoID: '',
    titleOfVideo: '',
    description: '',
    category: '',
    locationOfVideo: '',
    urlOfVideo: '',
    urlOfThumbnail: '',
  );

  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  void _changeDropDownValue(String value) {
    _dropDownValue = value;
  }

  void _changeProfilePhoto(File? videoFile) async {
    if (videoFile != null) {
      _videoFile = videoFile;
      final memImage =
          await VideoThumbnail.thumbnailFile(video: videoFile.path);
      setState(() {
        _thumbnail = File(memImage!);
      });
    } else {
      if (mounted) {
        setState(() {
          _thumbnail = null;
        });
      }
    }
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Name!';
    }
    return null;
  }

  String? _descValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Description!';
    }
    return null;
  }

  Future<Position> _geoCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate() && _thumbnail != null) {
      _formKey.currentState!.save();

      Position pos = await _geoCurrentLocation();

      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      _profile.profileID = widget.uid;
      _profile.videoID = uniqueFileName;
      _profile.titleOfVideo = _controllerTitle.text;
      _profile.description = _controllerDescription.text;
      _profile.category = _dropDownValue;
      _profile.locationOfVideo = '${pos.latitude}/${pos.longitude}';
      _dropDownValue = "Vlog";
      _controllerTitle.clear();
      _controllerDescription.clear();
      final String? tempLinkForVideo = await FireHelp().fireStorageUpload(
          profile: _profile, fileToUpload: _videoFile!, isVideo: true);
      final String? tempLinkForThumb = await FireHelp().fireStorageUpload(
          profile: _profile, fileToUpload: _thumbnail!, isVideo: false);
      _changeProfilePhoto(null);
      if (tempLinkForVideo != null && tempLinkForThumb != null) {
        _profile.urlOfVideo = tempLinkForVideo;
        _profile.urlOfThumbnail = tempLinkForThumb;
        await FireHelp().fireAddData(_profile).then(
              (value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text("Form Submitted!"),
                  ),
                  behavior: SnackBarBehavior.floating,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  duration: const Duration(milliseconds: 750),
                ),
              ),
            );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  late FocusNode _nameFocusNode;
  late FocusNode _descFocusNode;

  void _changeFocus(String text) {
    if (text == "Name: ") {
      _nameFocusNode.unfocus();
      _descFocusNode.requestFocus();
    } else if (text == "Description: ") {
      _descFocusNode.unfocus();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameFocusNode = FocusNode();
    _descFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerDescription.dispose();
    _nameFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 18),
                  child: const Text(
                    "Got something to share?",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                NeuTextField(
                  darkModeEnabled: widget._darkModeEnabled,
                  textLabel: "Name of Video: ",
                  textController: _controllerTitle,
                  textValidator: _nameValidator,
                  keyboardType: TextInputType.text,
                  capitalization: TextCapitalization.words,
                  focusNode: _nameFocusNode,
                  changeFocus: _changeFocus,
                ),
                const SizedBox(
                  height: 10,
                ),
                NeuTextField(
                  darkModeEnabled: widget._darkModeEnabled,
                  textLabel: "Description: ",
                  textController: _controllerDescription,
                  textValidator: _descValidator,
                  keyboardType: TextInputType.text,
                  capitalization: TextCapitalization.none,
                  focusNode: _descFocusNode,
                  changeFocus: _changeFocus,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    UploadVideo(
                      darkModeEnabled: widget._darkModeEnabled,
                      image: _thumbnail,
                      changePhoto: _changeProfilePhoto,
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 50,
                        margin: const EdgeInsets.only(right: 35),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          boxShadow: widget._darkModeEnabled
                              ? GlobalTraits.neuShadowsDark
                              : GlobalTraits.neuShadows,
                          color: widget._darkModeEnabled
                              ? GlobalTraits.bgGlobalColorDark
                              : GlobalTraits.bgGlobalColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: NeuDropdownButton(
                          initialDropDownValue: _dropDownValue,
                          setDropDownValue: _changeDropDownValue,
                          darkModeEnabled: widget._darkModeEnabled,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 45,
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : NeuButton(
                        buttonLabel: "Post",
                        darkModeEnabled: widget._darkModeEnabled,
                        performFunction: _submitForm,
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
