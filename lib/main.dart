import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vote/view/HomePage.dart';
import 'package:vote/view/SignIn.dart';
import 'package:vote/view/SignUp.dart';

void main() => runApp(MyApp());

// First put json file in android and json
// use gradle in android plugin
// yaml for firebase

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poll SignIn',
      theme: ThemeData(),
      home: SignIn(),
      routes: {
        '/home': (BuildContext context)=> HomeView(),
        '/signin': (BuildContext context)=> SignIn(),
        '/signup': (BuildContext context)=> SignUp(),
      },
    );
  }
}