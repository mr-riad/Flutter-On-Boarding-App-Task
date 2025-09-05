import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../services/location_service.dart';

class LocationController extends GetxController {
  final RxString location = ''.obs;
  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _requestPermissionOnEntry();
  }

  Future<void> _requestPermissionOnEntry() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission', 'Location permission is denied.');
        } else if (permission == LocationPermission.deniedForever) {
          _showOpenAppSettingsDialog(
            'Permission permanently denied. Open app settings to grant permission.',
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> getCurrentLocation() async {
    loading.value = true;
    try {
      Position pos = await LocationService.determinePosition();
      print("DEBUG: Lat=${pos.latitude}, Lng=${pos.longitude}");

      List<Placemark> placemarks =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);

      if (placemarks.isEmpty) {
        location.value = "Unable to fetch location name";
        print("DEBUG: placemarks list empty");
      } else {
        Placemark place = placemarks[0];
        print("DEBUG: Placemark data => $place");

        List<String> parts = [
          place.name ?? '',
          place.subLocality ?? '',
          place.locality ?? '',
          place.subAdministrativeArea ?? '',
          place.administrativeArea ?? '',
          place.country ?? '',
        ];

        parts.removeWhere((e) => e.trim().isEmpty);

        location.value = parts.join(', ');
      }

      Get.snackbar('Location Fetched', location.value);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("DEBUG ERROR: $e");
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
