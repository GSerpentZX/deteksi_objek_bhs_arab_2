import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'camera_view.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => CameraView());
          },
          child: Text('Mulai Kamera'),
        ),
      ),
    );
  }
}
