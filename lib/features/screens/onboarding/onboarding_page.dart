import 'package:flutter/material.dart';
import '../../models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel model;
  final VoidCallback onSkip;

  const OnboardingPage({super.key, required this.model, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes
    double imageHeight;
    double titleFontSize;
    double descFontSize;

    if (screenWidth < 550) {
      imageHeight = screenHeight * 0.50;
      titleFontSize = 20;
      descFontSize = 14;
    } else if (screenWidth >= 550 && screenWidth < 768) {
      imageHeight = screenHeight * 0.5;
      titleFontSize = 22;
      descFontSize = 16;
    } else if (screenWidth >= 768 && screenWidth < 1024) {
      imageHeight = screenHeight * 0.60;
      titleFontSize = 24;
      descFontSize = 18;
    } else {
      imageHeight = screenHeight * 0.65;
      titleFontSize = 28;
      descFontSize = 20;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: imageHeight,
                width: double.infinity,
                child: Image.asset(
                  model.image,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: TextButton(
                  onPressed: onSkip,
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            model.title,
            style: TextStyle(
                fontSize: titleFontSize, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              model.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: descFontSize),
            ),
          ),
        ],
      ),
    );
  }
}
