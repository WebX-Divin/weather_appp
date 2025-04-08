import 'package:dartz/dartz.dart';
import 'package:weather_appp/core/error/failure.dart';
import 'package:weather_appp/domain/repositories/weather_repository.dart';

class GetLastCityName {
  final WeatherRepository repository;

  GetLastCityName(this.repository);

  Future<Either<Failure, String>> execute() async {
    return await repository.getLastCityName();
  }
}
