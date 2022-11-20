import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Global/global.dart';
import 'detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    Key? key,
    required this.darkModeEnabled,
    required this.uid,
  }) : super(key: key);

  final bool darkModeEnabled;
  final String uid;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
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
                snapshot.data!.docs.map((DocumentSnapshot document) {
              return document.data()! as Map<String, dynamic>;
            }).toList();
            return Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemCount: snapshot.data!.docs.length,
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
                                height: 280,
                                width: double.infinity,
                                duration: const Duration(milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AnimatedContainer(
                                      height: 200,
                                      width: double.infinity,
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
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
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
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            listOfDataMaps[index]["Category"],
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
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
