import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';

import '../models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key,});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}


class _WeatherScreenState extends State<WeatherScreen> {

  final _weatherService=WeatherService('6a0ad78a64ef7a8c8082e3e4525bffde');
  Weather? _weather;

  _fetchWeather()async{
    String cityName=await _weatherService.getCurrentCity();

    try{
      final weather=await _weatherService.getWeather(cityName);
      setState(() {
        _weather=weather;
      });
    }
    catch (e){
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition ){
    if (mainCondition==null)return 'assets/sunny.json';

    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               const Icon(Icons.location_on, color: Colors.grey,size: 24,),
               Text(_weather?.cityName ?? 'Loading city...', style: const TextStyle(
                 fontSize: 24,
                 fontFamily: 'poppins',
                 color: Colors.grey,
               ),),
             ],
           ),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${_weather?.temperature.round()}°C", style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 34,
                  color: Colors.black87,
                ),),
                Text(_weather?.description??"Loading Description...", style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18
                ),),
              ],
            )
          ],
        ),
      ),
    );

  }
}