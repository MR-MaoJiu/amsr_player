import 'dart:async';
import 'package:amsr_player/config/api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'index_page.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      title: '共享ASMR播放器',
      home: _SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<_SplashPage> {
  Timer timer;
  var count = 5;

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      new Image.network(
        ggyAPI,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      new Positioned(
        top: 20.0,
        right: 10.0,
        child: new FlatButton(
          child: new Text(
            '跳过 ${count}',
            style: new TextStyle(color: Colors.white),
          ),
          color: Color.fromARGB(55, 0, 0, 0),
          onPressed: () {
            goHomePage();
          },
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    countDown();
  }

  //倒计时
  void countDown() {
    timer = new Timer(new Duration(seconds: 1), () {
      // 只在倒计时结束时回调
      if (count != 1) {
        setState(() {
          count = count - 1;
          countDown();
        });
      } else {
        timer.cancel();
        goHomePage();
      }
    });
  }

//  跳转主页
  void goHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => IndexPage()),
            (route) => route == null);
  }
}
