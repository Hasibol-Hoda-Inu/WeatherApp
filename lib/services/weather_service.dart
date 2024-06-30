import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const _baseURL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    try {
      final response = await http.get(Uri.parse('$_baseURL?q=$cityName&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        print("Weather data received: ${response.body}"); // Logging
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        print("Failed to load weather data: ${response.statusCode}"); // Logging
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print("Error: $e"); // Logging
      throw Exception('Failed to load weather data: $e');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      String? city = placemarks[0].locality;
      return city ?? '';
    } catch (e) {
      print("Error: $e"); // Logging
      throw Exception('Failed to get current city: $e');
    }
  }
}
