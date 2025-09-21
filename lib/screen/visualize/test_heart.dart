import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class TestHeart extends StatelessWidget {
  const TestHeart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ModelViewer(
          src: 'assets/human_heart.glb',
          alt: "Human Heart 3D Model",
          ar: true,
          autoRotate: true,
          cameraControls: true,
        ),
      ),
    );
  }
}
