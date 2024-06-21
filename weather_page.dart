import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('8b0d915ceb7097dcf6146c314b3d0b27');
  Weather? _weather;

  //fetch weather

  _fetchWeather() async {
    // get the current city

    String cityName = await _weatherService.getCurrentCity();

    // get weather  for city

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //any errors

    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'images/n.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'images/h.json';

      case'cloud':
      case'cloudy':
        return 'images/c.json';

      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'r.json';

      case 'thunderstorm':
        return 'images/t.json';

      case 'cold':
        return' images/c.json';

      case 'night':
      return 'images/s.json';


      default:
        return 'images/n.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/w.jpg'),
            fit: BoxFit.cover,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 181, 50, 50),
                size: 40,
              ),

              //city name
              Text(_weather?.cityName ?? "loading city...",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 25)),

              // animations
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              const SizedBox(
                height: 50,
              ),

              //temperature
              Text('${_weather?.temperature.round()}°C',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 25)),

              //weather condition
              Text(_weather?.mainCondition ?? "",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 25)),
            ],
          ),
        ),
      ),
    );
  }
}
