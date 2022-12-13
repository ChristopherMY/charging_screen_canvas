import 'package:charging_screen/data_backup_cloud_page.dart';
import 'package:charging_screen/data_backup_completed_page.dart';
import 'package:charging_screen/data_backup_initial_page.dart';
import 'package:flutter/material.dart';

const mainDataBackupColor = Color(0xFF5113AA);
const secondaryDataBackupColor = Color(0xFFBC53DA);
const backgroundColor = Color(0xFFFCE7FE);

class DataBackupHome extends StatefulWidget {
  const DataBackupHome({Key? key}) : super(key: key);

  @override
  State<DataBackupHome> createState() => _DataBackupHomeState();
}

class _DataBackupHomeState extends State<DataBackupHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _cloudOutAnimation;
  late Animation<double> _endingAnimation;

  @override
  void initState() {
    // TODO: implement initState

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );

    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.65),
    );

    _cloudOutAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.70, 0.85),
    );

    _endingAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.80, 1.0),
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          DataBackupInitialPage(
            progressAnimation: _progressAnimation,
            onAnimationStarted: () {
              _animationController.forward(from: 0.0);
            },
          ),
          DataBackupCloudPage(
            cloudOutAnimation: _cloudOutAnimation,
            progressAnimation: _progressAnimation,
          ),
          DataBackupCompletedPage(
            endingAnimation: _endingAnimation,
          ),
        ],
      ),
    );
  }
}
