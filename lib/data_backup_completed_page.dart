import 'package:charging_screen/data_backup_home.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class DataBackupCompletedPage extends AnimatedWidget {
  const DataBackupCompletedPage({Key? key, required this.endingAnimation})
      : super(key: key, listenable: endingAnimation);

  final Animation<double> endingAnimation;

  Animation<double> get animation => (listenable as Animation<double>);

  @override
  Widget build(BuildContext context) {
    return animation.value > 0
        ? Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomPaint(
                      foregroundPainter: _DataBackupCompletedPainter(animation),
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60.0),
                Expanded(
                  child: TweenAnimationBuilder(
                    tween: Tween(
                      begin: 0.0,
                      end: 1.0,
                    ),
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      // setState(() {
                      //   _currentState = DataBackupState.end;
                      // });
                    },
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0.0, 50 * (1 - value)),
                        child: child,
                      );
                    },
                    child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "data has successfully\nuploaded",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 20.0,
                            ),
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                color: mainDataBackupColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

class _DataBackupCompletedPainter extends CustomPainter {
  _DataBackupCompletedPainter(this.animation) : super(repaint: animation);
  Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = mainDataBackupColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final circlePath = Path();
    circlePath.addArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        height: size.height,
        width: size.width,
      ),
      vector.radians(-90.0),
      vector.radians(360.0),
    );

    /// 20%
    final leftLine = size.width * 0.2;

    /// 40%
    final rightLine = size.width * 0.3;

    canvas.save();

    canvas.translate(size.width / 3, size.height / 2);
    canvas.rotate(vector.radians(-45.0));

    canvas.drawLine(Offset.zero, Offset(0.0, leftLine), paint);
    canvas.drawLine(Offset(0.0, leftLine), Offset(rightLine, leftLine), paint);

    canvas.restore();
    canvas.drawPath(circlePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
