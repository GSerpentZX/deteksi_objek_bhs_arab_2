import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';

class ScanController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var arabObjectDetection;

  double h = 0.0;
  double w = 0.0;
  double x = 0.0;
  double y = 0.0;
  String label = '';

  @override
  void onInit() {
    super.onInit();
    initTFLite();
    initCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max,
          imageFormatGroup: ImageFormatGroup.yuv420);

      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            detectArabObject(image);
          }
          update();
        });
      });
      isCameraInitialized.value = true;
    } else {
      print('Kamera ditolak');
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  detectArabObject(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      rotation: 90,
      threshold: 0.4,
    );

    if (detector != null && detector.isNotEmpty) {
      arabObjectDetection = detector.first;

      if (arabObjectDetection['confidence'] * 100 > 45) {
        label = arabObjectDetection['label'].toString();
        print('Label: $label');
        print('Detektor: $arabObjectDetection');
      }
      update();
    }
  }
}
