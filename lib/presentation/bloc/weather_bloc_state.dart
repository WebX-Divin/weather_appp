part of 'weather_bloc_bloc.dart';

abstract class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded(this.weather);

  @override
  List<Object?> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}
