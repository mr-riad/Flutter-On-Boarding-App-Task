import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

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

      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

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
