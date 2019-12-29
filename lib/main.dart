import 'package:amsr_player/pages/splashPage_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '共享ASMR播放器',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SplashPage(),
    );
  }
}

