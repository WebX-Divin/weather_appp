import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.condition,
    required super.humidity,
    required super.windSpeed,
    required super.sunrise,
    required super.sunset,
    required super.forecast,
  });

  factory WeatherModel.fromJson(Map<dynamic, dynamic> json) {
    final currentWeather = json;

    List<ForecastDay> forecastList = [];
    if (json['forecast'] != null && json['forecast']['list'] != null) {
      forecastList = (json['forecast']['list'] as List)
          .take(5)
          .map((item) => ForecastDayModel.fromJson(item))
          .toList();
    }

    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      temperature: (currentWeather['main']['temp'] as num).toDouble(),
      condition: currentWeather['weather'][0]['main'],
      humidity: currentWeather['main']['humidity'],
      windSpeed: (currentWeather['wind']['speed'] as num).toDouble(),
      sunrise: DateTime.fromMillisecondsSinceEpoch(
          currentWeather['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(
          currentWeather['sys']['sunset'] * 1000),
      forecast: forecastList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {
        'temp': temperature,
        'humidity': humidity,
      },
      'weather': [
        {'main': condition}
      ],
      'wind': {
        'speed': windSpeed,
      },
      'sys': {
        'sunrise': sunrise.millisecondsSinceEpoch ~/ 1000,
        'sunset': sunset.millisecondsSinceEpoch ~/ 1000,
      },
      'forecast': {
        'list': forecast.map((f) => (f as ForecastDayModel).toJson()).toList(),
      },
    };
  }
}

class ForecastDayModel extends ForecastDay {
  const ForecastDayModel({
    required super.dateTime,
    required super.temperature,
    required super.condition,
  });

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) {
    return ForecastDayModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature,
      },
      'weather': [
        {'main': condition}
      ],
    };
  }
}
