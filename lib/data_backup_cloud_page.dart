import 'dart:math' as math;

import 'package:charging_screen/data_backup_home.dart';
import 'package:flutter/material.dart';

class _Bubble {
  _Bubble({
    required this.color,
    required this.direction,
    required this.speed,
    required this.size,
    required this.initialPosition,
  });

  final Color color;
  final double direction;
  final double speed;
  final double size;
  final double initialPosition;
}

class DataBackupCloudPage extends StatelessWidget {
  DataBackupCloudPage({
    Key? key,
    required this.cloudOutAnimation,
    required this.progressAnimation,
  }) : super(key: key);

  final Animation<double> cloudOutAnimation;
  final Animation<double> progressAnimation;
  final bubbles = List<_Bubble>.generate(500, (index) {
    final size = math.Random().nextInt(20) + 5.0;
    final speed = math.Random().nextInt(50) + 1.0;
    final directionRandom = math.Random().nextBool();
    final colorRandom = math.Random().nextBool();
    final direction =
        (math.Random().nextInt(250) * (directionRandom ? 1.0 : -1.0));
    final color = colorRandom ? mainDataBackupColor : secondaryDataBackupColor;
    return _Bubble(
      color: color,
      direction: direction,
      speed: speed,
      size: size,
      initialPosition: index * 10.0,
    );
  });

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge([progressAnimation, cloudOutAnimation]),
      builder: (context, snapshot) {
        final size = queryData.width * 0.5;
        final topPosition = queryData.height * 0.45;

        final circleSize = size *
            math.pow(
                (progressAnimation.value + cloudOutAnimation.value + 1), 2);
        final centerMargin = queryData.width - circleSize;

        final leftSize = size * 0.6 * (1 - progressAnimation.value);
        final rightSize = size * 0.7 * (1 - progressAnimation.value);

        final leftMargin = (queryData.width / 2) - leftSize * 1.2;
        final rightMargin = (queryData.width / 2) - rightSize * 1.2;
        final middleMargin =
            (queryData.width / 2) - (size / 2) * (1 - progressAnimation.value);

        final topOutPosition = queryData.height * cloudOutAnimation.value;
        return Positioned(
          left: 0,
          right: 0,
          top: topPosition - circleSize + topOutPosition,
          height: circleSize,
          child: Stack(
            children: [
              Positioned(
                height: leftSize / 2,
                width: size * (1 - progressAnimation.value),
                left: middleMargin,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                height: leftSize,
                width: leftSize,
                left: leftMargin,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                height: rightSize,
                width: rightSize,
                right: rightMargin,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                height: circleSize,
                width: circleSize,
                bottom: 0,
                left: centerMargin / 2,
                child: ClipOval(
                  child: CustomPaint(
                    foregroundPainter:
                        _CloudBubblePainter(progressAnimation, bubbles),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CloudBubblePainter extends CustomPainter {
  _CloudBubblePainter(this.animation, this.bubbles) : super(repaint: animation);

  final Animation<double> animation;
  final List<_Bubble> bubbles;

  @override
  void paint(Canvas canvas, Size size) {
    for (_Bubble bubble in bubbles) {
      final offset = Offset(
        size.width / 2 + bubble.direction * animation.value,
        (size.height * 1.2) * (1 - animation.value) -
            bubble.speed * animation.value +
            bubble.initialPosition * (1 - animation.value),
      );
      canvas.drawCircle(offset, bubble.size, Paint()..color = bubble.color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
