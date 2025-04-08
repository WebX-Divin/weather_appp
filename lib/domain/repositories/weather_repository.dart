import 'package:weather_appp/core/error/failure.dart';
import '../entities/weather.dart';
import 'package:dartz/dartz.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getWeatherForCity(String cityName);
  Future<Either<Failure, Weather>> getLastWeather();
  Future<Either<Failure, String>> getLastCityName();
}
