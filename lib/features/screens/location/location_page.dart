import 'package:flutter/material.dart';
import 'package:flutter_onboarding_app_task/constants/app_strings.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../controllers/location_controller.dart';

class LocationPage extends GetView<LocationController> {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocationController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive font sizes
    double titleFontSize;
    double subTitleFontSize;
    double buttonFontSize;
    double displayFontSize;
    double imageSize;
    double buttonHeight;

    if (screenWidth < 550) {
      titleFontSize = 22;
      subTitleFontSize = 14;
      buttonFontSize = 14;
      displayFontSize = 12;
      imageSize = 150;
      buttonHeight = 45;
    } else if (screenWidth >= 550 && screenWidth < 768) {
      titleFontSize = 26;
      subTitleFontSize = 16;
      buttonFontSize = 16;
      displayFontSize = 14;
      imageSize = 180;
      buttonHeight = 50;
    } else if (screenWidth >= 768 && screenWidth < 1024) {
      titleFontSize = 28;
      subTitleFontSize = 18;
      buttonFontSize = 18;
      displayFontSize = 16;
      imageSize = 200;
      buttonHeight = 55;
    } else {
      titleFontSize = 32;
      subTitleFontSize = 20;
      buttonFontSize = 20;
      displayFontSize = 18;
      imageSize = 250;
      buttonHeight = 60;
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.locationTitle,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.locationSubTitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: subTitleFontSize,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),

              // Responsive Image
              Container(
                height: imageSize,
                width: imageSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/home1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              Obx(
                    () => controller.loading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : GestureDetector(
                  onTap: controller.getCurrentLocation,
                  child: Container(
                    height: buttonHeight,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.locationButtonColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.locationButtonColor
                              .withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Use Current Location",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.location_on,
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              GestureDetector(
                onTap: () {
                  Get.toNamed('/home');
                },
                child: Container(
                  height: buttonHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppColors.locationButtonColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.locationButtonColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              Obx(
                    () => controller.location.value.isNotEmpty
                    ? Text(
                  'Selected Location: ${controller.location.value}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: displayFontSize,
                  ),
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
