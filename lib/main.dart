import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'features/services/notification_service.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));

  await NotificationService.init();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const FlutterOnBoardAppTask(),
    ),
  );
}
