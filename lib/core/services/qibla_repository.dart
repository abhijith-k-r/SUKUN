import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:sukun/features/qibla/model/qibla_data.dart';

class QiblaRepository {
  static const String _baseUrl = 'https://api.aladhan.com/v1';

  // Makkah coordinates
  static const double makkahLat = 21.4225;
  static const double makkahLon = 39.8262;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getLocationName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.locality ?? place.subAdministrativeArea ?? 'Unknown'}, ${place.country ?? ''}';
      }
    } catch (e) {
      print('Error getting location name: $e');
    }
    return 'Unknown Location';
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  Future<QiblaData> getQiblaDirection(double lat, double lon) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/qibla/$lat/$lon'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final qiblaData = QiblaData.fromJson(jsonData);

        // Get location name
        final locationName = await getLocationName(lat, lon);

        // Calculate distance to Makkah
        final distance = calculateDistance(lat, lon, makkahLat, makkahLon);

        return qiblaData.copyWith(
          locationName: locationName,
          distanceToMakkah: distance,
        );
      } else {
        throw Exception('Failed to load Qibla direction');
      }
    } catch (e) {
      throw Exception('Error fetching Qibla data: $e');
    }
  }

  Future<TimingsData> getPrayerTimings(double lat, double lon) async {
    try {
      final now = DateTime.now();
      final timestamp = (now.millisecondsSinceEpoch / 1000).round();

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/timings/$timestamp?latitude=$lat&longitude=$lon&method=2',
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TimingsData.fromJson(jsonData);
      } else {
        throw Exception('Failed to load prayer timings');
      }
    } catch (e) {
      throw Exception('Error fetching prayer timings: $e');
    }
  }
}
