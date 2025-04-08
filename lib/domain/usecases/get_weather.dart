import 'package:dartz/dartz.dart';
import 'package:weather_appp/core/error/failure.dart';
import 'package:weather_appp/domain/entities/weather.dart';
import 'package:weather_appp/domain/repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  Future<Either<Failure, Weather>> execute(String cityName) async {
    return await repository.getWeatherForCity(cityName);
  }
}
