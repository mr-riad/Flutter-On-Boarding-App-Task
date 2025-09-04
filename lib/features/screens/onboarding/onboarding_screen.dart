import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/custom_button.dart';
import '../../controllers/onboarding_controller.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  final controller = Get.put(OnboardingController());
  final PageController pageController = PageController();

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: controller.pages.length,
                onPageChanged: controller.updatePage,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    model: controller.pages[index],
                    onSkip: controller.skipOnboarding,
                  );
                },
              ),
            ),

            // Dots Indicator
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.pages.length,
                    (index) => Container(
                  margin: const EdgeInsets.all(4),
                  width: controller.currentPage.value == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.currentPage.value == index
                        ? Colors.blue
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            )),
            const SizedBox(height: 20),

            Obx(() => CustomButton(
              text: controller.currentPage.value ==
                  controller.pages.length - 1
                  ? "Get Started"
                  : "Next",
              onTap: () {
                if (controller.currentPage.value <
                    controller.pages.length - 1) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  controller.skipOnboarding();
                }
              },
            )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
