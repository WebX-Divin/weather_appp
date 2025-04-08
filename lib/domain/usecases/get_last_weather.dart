import 'package:dartz/dartz.dart';
import 'package:weather_appp/core/error/failure.dart';
import 'package:weather_appp/domain/entities/weather.dart';
import 'package:weather_appp/domain/repositories/weather_repository.dart';

class GetLastWeather {
  final WeatherRepository repository;

  GetLastWeather(this.repository);

  Future<Either<Failure, Weather>> execute() async {
    return await repository.getLastWeather();
  }
}
