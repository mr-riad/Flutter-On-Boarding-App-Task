import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationController extends GetxController {
  final RxString location = ''.obs;
  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // When page opens, ensure permission request happens if needed.
    _requestPermissionOnEntry();
  }

  Future<void> _requestPermissionOnEntry() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request permission once when entering page
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission', 'Location permission is denied.');
        } else if (permission == LocationPermission.deniedForever) {
          _showOpenAppSettingsDialog(
              'Permission permanently denied. Open app settings to grant permission.');
        }
      }
    } catch (e) {
      // safe fallback
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> getCurrentLocation() async {
    loading.value = true;
    try {
      // 1) Check if location service (GPS) is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Ask user to enable GPS
        final open = await Get.defaultDialog<bool>(
          title: 'GPS is off',
          middleText:
          'Please enable location services (GPS) to use current location.',
          textConfirm: 'Open Settings',
          textCancel: 'Cancel',
          onConfirm: () async {
            await Geolocator.openLocationSettings();
            Get.back(result: true);
          },
          onCancel: () => Get.back(result: false),
        );
        loading.value = false;
        if (open == true) {
          // user opened settings; you may wait or let them press button again
          Get.snackbar('Info', 'Opened location settings.');
        }
        return;
      }

      // 2) Check/request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission', 'Location permission denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showOpenAppSettingsDialog(
            'Location permission permanently denied. Open app settings to grant permission.');
        return;
      }

      // 3) Get position
      Position pos = await LocationService.determinePosition();
      location.value =
      '${pos.latitude.toStringAsFixed(6)}, ${pos.longitude.toStringAsFixed(6)}';
      Get.snackbar('Location Fetched', location.value);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  void _showOpenAppSettingsDialog(String message) {
    Get.defaultDialog(
      title: 'Permission needed',
      middleText: message,
      textConfirm: 'Open Settings',
      textCancel: 'Cancel',
      onConfirm: () async {
        await Geolocator.openAppSettings();
        Get.back();
      },
    );
  }
}
