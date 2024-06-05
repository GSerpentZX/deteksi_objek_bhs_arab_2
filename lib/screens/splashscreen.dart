import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deteksi_objek_bhs_arab_2/screens/dashboard.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Get.off(Dashboard());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Splash Screen', style: TextStyle(fontSize: 24)),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
