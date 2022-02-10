import 'dart:async';

import 'package:crop_seller/_screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return splash_state();
  }
}

class splash_state extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.light,
    ));
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/splashbg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(children: [
          Center(
            child: Image.asset(
              "images/trans_logo.png",
              width: MediaQuery.of(context).size.width - 100,
            ),
          ),
          const Positioned.fill(
            bottom: 100,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(),
            ),
          ),
        ]));
  }

  @override
  void initState() {
    super.initState();
    checkIsLogin();
  }

  checkIsLogin() async {
    var preferences = SharedPreferences.getInstance();
    SharedPreferences preff = await preferences;
    var isLogin = preff.getBool("islogin") ?? false;
    Timer(
      const Duration(microseconds: 1500),
      () => {
        if (isLogin)
          {Navigator.pushReplacement(context, _createRoute(Dashboard()))}
        else
          {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ))
          }
      },
    );
  }
}

Route _createRoute(Widget destination) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destination,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
