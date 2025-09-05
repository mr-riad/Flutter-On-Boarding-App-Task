import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../controllers/alarm_controller.dart';
import '../../controllers/location_controller.dart';
import '../../../common_widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final alarmController = Get.put(AlarmController());
  final locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    requestNotificationPermission(); // request permission at startup

    final screenWidth = MediaQuery.of(context).size.width;

    double titleFontSize;
    double descFontSize;

    if (screenWidth < 550) {
      titleFontSize = 20;
      descFontSize = 14;
    } else if (screenWidth >= 550 && screenWidth < 768) {
      titleFontSize = 22;
      descFontSize = 16;
    } else if (screenWidth >= 768 && screenWidth < 1024) {
      titleFontSize = 24;
      descFontSize = 18;
    } else {
      titleFontSize = 28;
      descFontSize = 20;
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                AppStrings.selectedLocation,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                            () => Text(
                          locationController.location.value.isEmpty
                              ? AppStrings.noLocationSelected
                              : locationController.location.value,
                          style: TextStyle(color: Colors.white, fontSize: descFontSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: AppStrings.addAlarm,
                color: AppColors.locationButtonColor,
                textColor: Colors.white,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) =>
                        Theme(data: ThemeData.dark(), child: child!),
                  );
                  if (picked == null) return;

                  final now = DateTime.now();
                  DateTime dt = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    picked.hour,
                    picked.minute,
                  );
                  if (dt.isBefore(now)) dt = dt.add(const Duration(days: 1));
                  alarmController.addAlarm(dt);

                  Get.snackbar(
                    AppStrings.alarmSetTitle,
                    '${AppStrings.alarmSetDesc} ${DateFormat.jm().format(dt)}',
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(AppStrings.myAlarms,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 10),
              Obx(
                    () => Expanded(
                  child: alarmController.alarms.isEmpty
                      ? Center(
                    child: Text(
                      AppStrings.noAlarms,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white54, fontSize: descFontSize),
                    ),
                  )
                      : ListView.builder(
                    itemCount: alarmController.alarms.length,
                    itemBuilder: (_, i) {
                      final alarm = alarmController.alarms[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.locationButtonColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat.jm().format(alarm.dateTime),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      DateFormat('EEE dd MMM yyyy')
                                          .format(alarm.dateTime),
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: descFontSize,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: alarm.isActive,
                              onChanged: (_) =>
                                  alarmController.toggleAlarm(alarm),
                              activeColor: AppColors.obButtonColor,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
}
