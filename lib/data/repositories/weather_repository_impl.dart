import 'package:dartz/dartz.dart';
import 'package:weather_appp/core/error/failure.dart';
import 'package:weather_appp/data/datasources/weather_local_datasource.dart';
import 'package:weather_appp/data/datasources/weather_remote_datasource.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';

import '../../../core/network/network_info.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Weather>> getWeatherForCity(String cityName) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteWeather =
            await remoteDataSource.getWeatherForCity(cityName);
        await localDataSource.cacheWeather(remoteWeather);
        await localDataSource.cacheCityName(cityName);
        return Right(remoteWeather);
      } on ServerFailure catch (e) {
        return Left(e);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final localWeather = await localDataSource.getLastWeather();
        return Right(localWeather);
      } on CacheFailure {
        return Left(
            NetworkFailure('No internet connection and no cached data'));
      }
    }
  }

  @override
  Future<Either<Failure, Weather>> getLastWeather() async {
    try {
      final localWeather = await localDataSource.getLastWeather();
      return Right(localWeather);
    } on CacheFailure {
      return Left(CacheFailure('No cached weather found'));
    }
  }

  @override
  Future<Either<Failure, String>> getLastCityName() async {
    final cityName = await localDataSource.getLastCityName();
    if (cityName != null) {
      return Right(cityName);
    } else {
      return Left(CacheFailure('No cached city name found'));
    }
  }
}
