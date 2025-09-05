import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/alarm_model.dart';
import '../services/notification_service.dart';

class AlarmController extends GetxController {
  RxList<AlarmModel> alarms = <AlarmModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAlarms();
  }

  void addAlarm(DateTime time) async {
    final alarm = AlarmModel(
      id: DateTime.now().millisecondsSinceEpoch,
      dateTime: time,
      isActive: true,
    );
    alarms.add(alarm);
    await saveAlarms();
    NotificationService.scheduleAlarm(alarm);
  }

  void toggleAlarm(AlarmModel alarm) async {
    alarm.isActive = !alarm.isActive;
    if (alarm.isActive) {
      NotificationService.scheduleAlarm(alarm);
    } else {
      NotificationService.cancelAlarm(alarm.id);
      NotificationService.showAlarmOffNotification(alarm);
    }
    await saveAlarms();
    alarms.refresh();
  }

  Future<void> saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmList = alarms.map((a) => a.toJsonString()).toList();
    await prefs.setStringList('alarms', alarmList);
  }

  Future<void> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('alarms');
    if (stored != null) {
      alarms.value =
          stored.map((s) => AlarmModel.fromJsonString(s)).toList();
    }
  }
}
