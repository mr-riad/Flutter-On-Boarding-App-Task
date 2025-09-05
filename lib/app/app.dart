import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../binding/location_binding.dart';
import '../features/screens/home/home_page.dart';
import '../features/screens/location/location_page.dart';
import '../features/screens/onboarding/onboarding_screen.dart';

class FlutterOnBoardAppTask extends StatelessWidget {
  const FlutterOnBoardAppTask({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Onboarding App',
      theme: ThemeData.dark(),

      initialRoute: '/',

      getPages: [
        GetPage(
          name: '/',
          page: () => OnboardingScreen(),
        ),
        GetPage(
          name: '/location',
          page: () => const LocationPage(),
          binding: LocationBinding(),
        ),
        GetPage(
          name: '/home',
          page: () => HomePage(),
        ),
      ],
    );
  }
}
