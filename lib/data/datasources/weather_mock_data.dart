import '../models/weather_model.dart';

class MockWeatherData {
  static WeatherModel getMockWeather() {
    return WeatherModel(
      cityName: 'Salem',
      temperature: 90.5,
      condition: 'Clear',
      humidity: 65,
      windSpeed: 5.2,
      sunrise: DateTime.now().subtract(const Duration(hours: 6)),
      sunset: DateTime.now().add(const Duration(hours: 6)),
      forecast: List.generate(
        8,
        (index) => ForecastDayModel(
          dateTime: DateTime.now().add(Duration(hours: index * 3)),
          temperature: 22.0 + (index % 3) - 1,
          condition: index % 2 == 0 ? 'Clear' : 'Clouds',
        ),
      ),
    );
  }
}
