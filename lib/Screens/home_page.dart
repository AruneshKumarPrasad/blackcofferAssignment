import 'package:blackcoffer/Helpers/firebase.dart';
import 'package:blackcoffer/Screens/explore_screen.dart';
import 'package:blackcoffer/Screens/uploads_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Global/global.dart';
import 'post_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.darkMode,
      this.changeDarkMode,
      required this.uid})
      : super(key: key);
  final bool darkMode;
  final dynamic changeDarkMode;
  final String uid;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  late bool _darkModeEnabled;
  late PageController _pageController;

  late String uid = '';

  void setUID(String getUID) {
    uid = getUID;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = widget.uid;
    _darkModeEnabled = widget.darkMode;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: AnimatedDefaultTextStyle(
            style: _darkModeEnabled
                ? const TextStyle(fontSize: 32, color: Colors.white)
                : const TextStyle(fontSize: 32, color: Colors.black),
            duration: const Duration(milliseconds: 500),
            child: AnimatedCrossFade(
              firstChild: _currentIndex == 0
                  ? const Text("Explore")
                  : const Text("Post"),
              secondChild: const Text("My Uploads"),
              duration: const Duration(milliseconds: 250),
              crossFadeState: _currentIndex == 0
                  ? CrossFadeState.showFirst
                  : _currentIndex == 1
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.darkMode) {
                    widget.changeDarkMode(ThemeMode.light);
                    _darkModeEnabled = false;
                  } else {
                    widget.changeDarkMode(ThemeMode.dark);
                    _darkModeEnabled = true;
                  }
                });
              },
              child: AnimatedContainer(
                margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _darkModeEnabled
                      ? GlobalTraits.neuShadowsCircularDark
                      : GlobalTraits.neuShadowsCircular,
                  color: _darkModeEnabled
                      ? GlobalTraits.bgGlobalColorDark
                      : GlobalTraits.bgGlobalColor,
                ),
                duration: const Duration(milliseconds: 200),
                child: _darkModeEnabled
                    ? Icon(
                        Icons.light_mode,
                        color: GlobalTraits.bgGlobalColor,
                      )
                    : Icon(
                        Icons.dark_mode,
                        color: GlobalTraits.bgGlobalColorDark,
                      ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FireHelp().fireSignOut();
                Navigator.pop(context);
                SystemNavigator.pop();
              },
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 10, bottom: 10, right: 14),
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: _darkModeEnabled
                        ? GlobalTraits.neuShadowsCircularDark
                        : GlobalTraits.neuShadowsCircular,
                    color: _darkModeEnabled
                        ? GlobalTraits.bgGlobalColorDark
                        : GlobalTraits.bgGlobalColor,
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: _darkModeEnabled
                        ? GlobalTraits.bgGlobalColor
                        : GlobalTraits.bgGlobalColorDark,
                  )),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: <Widget>[
          ExploreScreen(darkModeEnabled: _darkModeEnabled, uid: uid),
          PostScreen(
            darkModeEnabled: _darkModeEnabled,
            uid: uid,
          ),
          UploadScreen(darkModeEnabled: _darkModeEnabled, uid: uid),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        height: 100,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            boxShadow: _darkModeEnabled
                ? GlobalTraits.neuShadowsDark
                : GlobalTraits.neuShadows,
            color: _darkModeEnabled
                ? GlobalTraits.bgGlobalColorDark
                : GlobalTraits.bgGlobalColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              });
            },
            currentIndex: _currentIndex,
            showSelectedLabels: false,
            selectedItemColor: Colors.black,
            selectedLabelStyle: TextStyle(
              fontSize: 12,
              color: _darkModeEnabled
                  ? GlobalTraits.bgGlobalColor
                  : GlobalTraits.bgGlobalColorDark,
            ),
            selectedIconTheme: IconThemeData(
              size: 25,
              color: _darkModeEnabled
                  ? GlobalTraits.bgGlobalColor
                  : GlobalTraits.bgGlobalColorDark,
            ),
            unselectedIconTheme: const IconThemeData(size: 20),
            showUnselectedLabels: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_a_photo_rounded),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'My Uploads',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
