import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_appp/core/error/failure.dart';
import 'package:weather_appp/core/utils/constants.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeatherForCity(String cityName);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getWeatherForCity(String cityName) async {
    try {
      final currentResponse = await client.get(
        Uri.parse(
            '${Constants.baseUrl}/weather?q=$cityName&appid=${Constants.apiKey}&units=metric'),
      );

      if (currentResponse.statusCode != 200) {
        throw ServerFailure(
            'Failed to fetch weather data: ${currentResponse.statusCode}');
      }

      final currentData = json.decode(currentResponse.body);

      final forecastResponse = await client.get(
        Uri.parse(
            '${Constants.baseUrl}/forecast?q=$cityName&appid=${Constants.apiKey}&units=metric'),
      );

      if (forecastResponse.statusCode != 200) {
        throw ServerFailure(
            'Failed to fetch forecast data: ${forecastResponse.statusCode}');
      }

      final forecastData = json.decode(forecastResponse.body);

      final combinedData = {
        ...currentData,
        'forecast': forecastData,
      };

      return WeatherModel.fromJson(combinedData.cast<String, dynamic>());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
