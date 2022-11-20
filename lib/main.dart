import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Global/global.dart';
import 'Screens/home_page.dart';
import 'Screens/phone_screen.dart';
import 'Screens/verify_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  ThemeMode _themeMode = ThemeMode.light;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  bool checkDarkTheme() {
    return _themeMode == ThemeMode.dark;
  }

  String currentUID = '';

  late StreamSubscription<User?> user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
      } else {
        currentUID = user.uid;
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Black Coffer',
      theme: ThemeData(
          fontFamily: 'OpenSans',
          brightness: Brightness.light,
          scaffoldBackgroundColor: GlobalTraits.bgGlobalColor,
          iconTheme: IconThemeData(
            color: GlobalTraits.bgGlobalColorDark,
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: GlobalTraits.bgGlobalColorDark,
            ),
          )
          /* light theme settings */
          ),
      darkTheme: ThemeData(
          fontFamily: 'OpenSans',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: GlobalTraits.bgGlobalColorDark,
          iconTheme: IconThemeData(
            color: GlobalTraits.bgGlobalColor,
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: GlobalTraits.bgGlobalColor,
            ),
          )
          /* dark theme settings */
          ),
      themeMode: _themeMode,
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? 'phone' : 'home',
      routes: {
        'phone': (context) => const MyPhone(),
        'verify': (context) => const MyVerify(),
        'home': (context) => MyHomePage(
              darkMode: _themeMode == ThemeMode.dark,
              changeDarkMode: changeTheme,
              uid: currentUID,
            ),
      },
    );
  }
}
