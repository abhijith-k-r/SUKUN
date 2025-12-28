import 'package:flutter/material.dart';
import 'dart:math' as math;

class CompassWidget extends StatelessWidget {
  final double qiblaDirection;

  const CompassWidget({super.key, required this.qiblaDirection});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1e293b),
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circles
            CustomPaint(
              size: const Size(320, 320),
              painter: CompassBackgroundPainter(),
            ),

            // Cardinal directions
            const Positioned(
              top: 16,
              child: Text(
                'N',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Positioned(
              bottom: 16,
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Positioned(
              left: 16,
              child: Text(
                'W',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Positioned(
              right: 16,
              child: Text(
                'E',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Rotating compass needle
            Transform.rotate(
              angle: qiblaDirection * (math.pi / 180),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Qibla label
                  Transform.rotate(
                    angle: -math.pi / 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF098958),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Text(
                        'QIBLA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Needle
                  SizedBox(
                    width: 64,
                    height: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // North pointer (red)
                        Positioned(
                          top: 0,
                          child: CustomPaint(
                            size: const Size(24, 60),
                            painter: NeedlePainter(color: Colors.red),
                          ),
                        ),

                        // South pointer (grey)
                        Positioned(
                          bottom: 0,
                          child: Transform.rotate(
                            angle: math.pi,
                            child: CustomPaint(
                              size: const Size(24, 60),
                              painter: NeedlePainter(color: Colors.grey[600]!),
                            ),
                          ),
                        ),

                        // Center dot
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompassBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Outer dashed circle
    paint.color = const Color(0xFF64748b);
    const dashWidth = 2.0;
    const dashSpace = 6.0;
    final outerRadius = size.width / 2 - 20;

    for (
      double i = 0;
      i < 360;
      i += (dashWidth + dashSpace) * 360 / (2 * math.pi * outerRadius)
    ) {
      final x1 = center.dx + outerRadius * math.cos(i * math.pi / 180);
      final y1 = center.dy + outerRadius * math.sin(i * math.pi / 180);
      final x2 =
          center.dx +
          outerRadius *
              math.cos(
                (i + dashWidth * 360 / (2 * math.pi * outerRadius)) *
                    math.pi /
                    180,
              );
      final y2 =
          center.dy +
          outerRadius *
              math.sin(
                (i + dashWidth * 360 / (2 * math.pi * outerRadius)) *
                    math.pi /
                    180,
              );
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Inner circle
    paint.color = const Color(0xFF475569);
    paint.strokeWidth = 0.2;
    canvas.drawCircle(center, size.width / 2 - 50, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NeedlePainter extends CustomPainter {
  final Color color;

  NeedlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
