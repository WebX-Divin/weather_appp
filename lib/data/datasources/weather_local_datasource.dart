import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_appp/core/error/failure.dart';
import '../models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<WeatherModel> getLastWeather();
  Future<void> cacheWeather(WeatherModel weatherToCache);
  Future<String?> getLastCityName();
  Future<void> cacheCityName(String cityName);
  Future<void> clearCache();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<WeatherModel> getLastWeather() async {
    final jsonString = sharedPreferences.getString('CACHED_WEATHER');
    if (jsonString != null) {
      return WeatherModel.fromJson(json.decode(jsonString));
    } else {
      throw CacheFailure('No cached weather found');
    }
  }

  @override
  Future<void> cacheWeather(WeatherModel weatherToCache) async {
    await sharedPreferences.setString(
      'CACHED_WEATHER',
      json.encode(weatherToCache.toJson()),
    );
  }

  @override
  Future<String?> getLastCityName() async {
    return sharedPreferences.getString('LAST_CITY_NAME');
  }

  @override
  Future<void> cacheCityName(String cityName) async {
    await sharedPreferences.setString('LAST_CITY_NAME', cityName);
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove('CACHED_WEATHER');
    await sharedPreferences.remove('LAST_CITY_NAME');
  }
}
