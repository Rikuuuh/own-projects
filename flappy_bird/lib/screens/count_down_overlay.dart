import 'package:flutter/material.dart';

class CountdownOverlay extends StatefulWidget {
  final VoidCallback onCountdownComplete;

  const CountdownOverlay({super.key, required this.onCountdownComplete});

  @override
  // ignore: library_private_types_in_public_api
  _CountdownOverlayState createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay> {
  int countdown = 3;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() async {
    for (int i = 3; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          countdown = i - 1;
        });
      }
    }
    widget.onCountdownComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Text(
          countdown > 0 ? countdown.toString() : '',
          style: const TextStyle(
              fontSize: 68, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
