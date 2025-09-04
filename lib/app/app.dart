import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/screens/onboarding/onboarding_screen.dart';

class FlutterOnBoardAppTask extends StatefulWidget {
  const FlutterOnBoardAppTask({super.key});

  @override
  State<FlutterOnBoardAppTask> createState() => _FlutterOnBoardAppTaskState();
}

class _FlutterOnBoardAppTaskState extends State<FlutterOnBoardAppTask> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
