import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';

import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/sun2.jpeg",
              height: 260,
              width: 260,
            ),
            const Text(
              "What is today's forecast?",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 62, 26, 59)),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Let's search it!",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 94, 4, 94)),
            ),
            const SizedBox(
              height: 50,
            ),
            const SpinKitThreeInOut(
              color: Color.fromARGB(255, 44, 61, 103),
              size: 50.0,
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 184, 174, 183),
    );
  }
}
