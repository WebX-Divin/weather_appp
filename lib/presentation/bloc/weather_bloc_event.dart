part of 'weather_bloc_bloc.dart';

abstract class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetWeatherForCityEvent extends WeatherEvent {
  final String cityName;

  GetWeatherForCityEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class GetInitialWeatherEvent extends WeatherEvent {}

class ClearCacheAndGetWeatherEvent extends WeatherEvent {
  final String cityName;

  ClearCacheAndGetWeatherEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}
