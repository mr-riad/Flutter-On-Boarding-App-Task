import 'package:get/get.dart';
import '../../constants/app_strings.dart';
import '../models/onboarding_model.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;

  List<OnboardingModel> pages = [
    OnboardingModel(
      image: "assets/images/onboard1.gif",
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
    ),
    OnboardingModel(
      image: "assets/images/onboard2.gif",
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
    ),
    OnboardingModel(
      image: "assets/images/onboard3.gif",
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDesc3,
    ),
  ];

  void updatePage(int index) {
    currentPage.value = index;
  }

  void skipOnboarding() {
    Get.offAllNamed('/location');
  }
}
