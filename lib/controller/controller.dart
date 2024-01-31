import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rapid_api/model/model.dart';
import 'package:rapid_api/service/service.dart';

import 'package:geolocator/geolocator.dart';

class GetDataController extends GetxController {
  var isDataLoading = false.obs;
  var isLocationLoading = false.obs;
  RxList<WelcomeSuccess?> saveData = <WelcomeSuccess?>[].obs;

  var q1 = ''.obs;
  var q2 = ''.obs;

  var searchAreaController = TextEditingController();

  Future<bool> getDataApi() async {
    try {
      isDataLoading(true);

      saveData.clear();
      debugPrint('api called');
      var welcomeSuccessList = await DataService().getData();
      debugPrint('welcomeSuccessList fetched...');
      saveData.addAll([welcomeSuccessList]);
      debugPrint('save data list $saveData');
      if (saveData.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to get data in controller $e');
    } finally {
      isDataLoading(false);
    }
  }
/////////////////////location fetch//////////////////////////

  String? currentAddress;
  Position? currentPosition;

  Future<bool> handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    print('service enabled');
    return true;
  }

  Future<void> getCurrentPosition(context) async {
    try {
      isLocationLoading(true);
      debugPrint('calld getCurrentPosition');
      final hasPermission = await handleLocationPermission(context);

      if (!hasPermission) return;

      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        currentPosition = position;
        q1.value = currentPosition?.latitude.toString() ?? "";
        q2.value = currentPosition?.longitude.toString() ?? "";
      }).catchError((e) {
        debugPrint('Error getting location: $e');
      });
    } catch (e) {
      debugPrint('Exception in getCurrentPosition: $e');
    } finally {
      isLocationLoading(false);
    }
  }
}
