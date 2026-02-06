import 'package:flutter/material.dart';
import 'splash_screen.dart';

class ReturningSplash extends StatefulWidget {
  const ReturningSplash({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<ReturningSplash> createState() => _ReturningSplashState();
}

class _ReturningSplashState extends State<ReturningSplash> {
  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  Future<void> _startDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen(showLogo: true);
  }
}
