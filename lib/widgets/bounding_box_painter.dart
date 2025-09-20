import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> objects;
  final List<Map<String, dynamic>> texts;
  final Size imageSize;

  BoundingBoxPainter({
    required this.objects,
    required this.texts,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final object in objects) {
      final boundingBox = object['boundingBox'];
      if (boundingBox != null) {
        final rect = _scaleRect(boundingBox, size);
        canvas.drawRect(rect, paint);

        final label = object['name'] ?? '';
        final confidence = object['confidence'] ?? 0.0;
        final textSpan = TextSpan(
          text: '$label (${confidence.toStringAsFixed(1)}%)',
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(rect.left, rect.top - textPainter.height),
        );
      }
    }
  }

  Rect _scaleRect(Map<String, dynamic> boundingBox, Size size) {
    final left = (boundingBox['Left'] ?? 0.0) * size.width;
    final top = (boundingBox['Top'] ?? 0.0) * size.height;
    final width = (boundingBox['Width'] ?? 0.0) * size.width;
    final height = (boundingBox['Height'] ?? 0.0) * size.height;

    return Rect.fromLTWH(left, top, width, height);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
