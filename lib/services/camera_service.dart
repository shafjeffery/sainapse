import 'package:camera/camera.dart';

class CameraService {
  Future<CameraController> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    return CameraController(camera, ResolutionPreset.high, enableAudio: false);
  }
}
