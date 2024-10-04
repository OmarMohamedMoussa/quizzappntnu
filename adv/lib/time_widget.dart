import 'dart:async';
import 'package:flutter/material.dart';

/// Widget that displays a timer and notifies the parent widget of the elapsed time
class TimerWidget extends StatefulWidget {
  // Sends the timers duration to the parent widget every second
  final Function(Duration) onTimerTick; // Callback to notify every second

  const TimerWidget({super.key, required this.onTimerTick});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

/// Creates a widget that start counting when added.
class _TimerWidgetState extends State<TimerWidget> {
  // keeps track of the elepsed time
  Duration duration = const Duration();

  // Increment the duration every second
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the timer when the widget is initialized
  }

  /// Initialized a periodic timer that updates every second
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        duration += const Duration(seconds: 1);
        widget.onTimerTick(duration); // Notify parent of timer update
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  /// How the widget looks like and how it is displayed
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: 25,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white, // color is set to white
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, //shadow
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
