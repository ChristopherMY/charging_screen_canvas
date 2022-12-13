import 'package:charging_screen/data_backup_home.dart';
import 'package:flutter/material.dart';

enum DataBackupState {
  initial,
  start,
  end,
}

const _duration = Duration(milliseconds: 500);

class DataBackupInitialPage extends StatefulWidget {
  const DataBackupInitialPage({
    Key? key,
    required this.onAnimationStarted,
    required this.progressAnimation,
  }) : super(key: key);

  final VoidCallback onAnimationStarted;
  final Animation<double> progressAnimation;

  @override
  State<DataBackupInitialPage> createState() => _DataBackupInitialPageState();
}

class _DataBackupInitialPageState extends State<DataBackupInitialPage> {
  DataBackupState _currentState = DataBackupState.initial;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              flex: 3,
              child: Text(
                "Cloud Storage",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
            ),
            if (_currentState == DataBackupState.end)
              Expanded(
                flex: 2,
                child: TweenAnimationBuilder(
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  tween: Tween(
                    begin: 0.0,
                    end: 1.0,
                  ),
                  duration: _duration,
                  child: Column(
                    children: [
                      const Text(
                        "uploading files",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Expanded(
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: _ProgressCounter(
                              progressAnimation: widget.progressAnimation,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_currentState != DataBackupState.end)
              Expanded(
                flex: 2,
                child: TweenAnimationBuilder(
                  tween: Tween(
                    begin: 1.0,
                    end: _currentState == DataBackupState.initial ? 0.0 : 1.0,
                  ),
                  duration: _duration,
                  onEnd: () {
                    setState(() {
                      _currentState = DataBackupState.end;
                    });
                  },
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0.0, -50 * value),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: const [
                      Text("last backup: "),
                      SizedBox(height: 10.0),
                      Text(
                        "28 may 2020",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AnimatedSwitcher(
                duration: _duration,
                child: _currentState == DataBackupState.initial
                    ? SizedBox(
                        width: size.width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                mainDataBackupColor),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            /// Test

                            setState(() {
                              _currentState = DataBackupState.start;
                            });

                            widget.onAnimationStarted();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "Create Backup",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : OutlinedButton(
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 20.0,
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: mainDataBackupColor,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }
}

class _ProgressCounter extends AnimatedWidget {
  const _ProgressCounter({Key? key, required this.progressAnimation})
      : super(key: key, listenable: progressAnimation);

  final Animation<double> progressAnimation;

  double get value => (listenable as Animation).value;

  @override
  Widget build(BuildContext context) {
    return Text("${(value * 100).truncate()}%");
  }
}
