import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/custom_button.dart';
import '../../controllers/location_controller.dart';

class LocationPage extends GetView<LocationController> {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocationController>(); // from binding

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome! Your Personalized Alarm",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Allow us to sync your sunset alarm based on your location.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/home1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                    () => controller.loading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : CustomButton(
                  text: "Use Current Location",
                  color: Colors.green,
                  onTap: controller.getCurrentLocation,
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Home",
                color: Colors.orange,
                onTap: () {
                  Get.toNamed('/home');
                },
              ),
              const SizedBox(height: 20),
              Obx(
                    () => controller.location.value.isNotEmpty
                    ? Text(
                  'Selected Location: ${controller.location.value}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 14),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
