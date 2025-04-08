import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final DateTime sunrise;
  final DateTime sunset;
  final List<ForecastDay> forecast;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.forecast,
  });

  @override
  List<Object> get props => [
    cityName,
    temperature,
    condition,
    humidity,
    windSpeed,
    sunrise,
    sunset,
    forecast,
  ];
}

class ForecastDay extends Equatable {
  final DateTime dateTime;
  final double temperature;
  final String condition;

  const ForecastDay({
    required this.dateTime,
    required this.temperature,
    required this.condition,
  });

  @override
  List<Object> get props => [dateTime, temperature, condition];
}