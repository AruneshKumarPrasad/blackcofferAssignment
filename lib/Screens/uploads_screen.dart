import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Global/global.dart';
import '../Helpers/firebase.dart';
import '../Helpers/models.dart';
import 'detail_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({
    Key? key,
    required this.darkModeEnabled,
    required this.uid,
  }) : super(key: key);

  final bool darkModeEnabled;
  final String uid;

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _deletePressed = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _performDelete(
      {required Model profile, required BuildContext cText}) async {
    await FireHelp().startDelete(profile: profile, ctx: cText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("videos").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else {
            List<Map<String, dynamic>> listOfDataMaps =
                snapshot.data!.docs.where((DocumentSnapshot element) {
              var currentDoc = element.data() as Map<String, dynamic>;
              return currentDoc["ID"] == widget.uid;
            }).map((DocumentSnapshot document) {
              return document.data()! as Map<String, dynamic>;
            }).toList();
            return Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemCount: listOfDataMaps.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 9,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(
                                    darkModeEnabled: widget.darkModeEnabled,
                                    profile: listOfDataMaps[index],
                                  ),
                                ),
                              );
                            },
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                height: 80,
                                decoration: BoxDecoration(
                                  boxShadow: widget.darkModeEnabled
                                      ? GlobalTraits.neuShadowsDark
                                      : GlobalTraits.neuShadows,
                                  color: widget.darkModeEnabled
                                      ? GlobalTraits.bgGlobalColorDark
                                      : GlobalTraits.bgGlobalColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AnimatedContainer(
                                      height: 60,
                                      width: 60,
                                      padding: const EdgeInsets.all(5),
                                      duration:
                                          const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        boxShadow: widget.darkModeEnabled
                                            ? GlobalTraits.neuShadowsDark
                                            : GlobalTraits.neuShadows,
                                        color: widget.darkModeEnabled
                                            ? GlobalTraits.bgGlobalColorDark
                                            : GlobalTraits.bgGlobalColor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          listOfDataMaps[index]["ThumbURL"],
                                          alignment: Alignment.center,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 32,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listOfDataMaps[index]["Name"],
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            listOfDataMaps[index]["Category"],
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Flexible(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              listOfDataMaps[index];
                              setState(() {
                                _deletePressed = !_deletePressed;
                                _performDelete(
                                    profile: Model(
                                        profileID: listOfDataMaps[index]['ID'],
                                        videoID: listOfDataMaps[index]
                                            ['VideoID'],
                                        titleOfVideo: listOfDataMaps[index]
                                            ['Name'],
                                        description: listOfDataMaps[index]
                                            ['Description'],
                                        category: listOfDataMaps[index]
                                            ['Category'],
                                        locationOfVideo: listOfDataMaps[index]
                                            ['Location'],
                                        urlOfVideo: listOfDataMaps[index]
                                            ['VideoURL'],
                                        urlOfThumbnail: listOfDataMaps[index]
                                            ['ThumbURL']),
                                    cText: context);
                                _deletePressed = !_deletePressed;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              height: 80,
                              width: 65,
                              decoration: BoxDecoration(
                                boxShadow: _deletePressed
                                    ? []
                                    : widget.darkModeEnabled
                                        ? GlobalTraits.neuShadowsDark
                                        : GlobalTraits.neuShadows,
                                color: widget.darkModeEnabled
                                    ? GlobalTraits.bgGlobalColorDark
                                    : GlobalTraits.bgGlobalColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: const Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Icons.delete,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
