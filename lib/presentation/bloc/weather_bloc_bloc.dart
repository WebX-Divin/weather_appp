import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_appp/data/datasources/weather_local_datasource.dart';
import 'package:weather_appp/data/datasources/weather_mock_data.dart';
import 'package:weather_appp/domain/entities/weather.dart';
import 'package:weather_appp/domain/usecases/get_last_city_name.dart';
import 'package:weather_appp/domain/usecases/get_last_weather.dart';
import 'package:weather_appp/domain/usecases/get_weather.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;
  final GetLastWeather getLastWeather;
  final GetLastCityName getLastCityName;
  final WeatherLocalDataSource localDataSource;

  WeatherBloc({
    required this.getWeather,
    required this.getLastWeather,
    required this.getLastCityName,
    required this.localDataSource,
  }) : super(WeatherInitial()) {
    on<GetWeatherForCityEvent>(_onGetWeatherForCity);
    on<GetInitialWeatherEvent>(_onGetInitialWeather);
    on<ClearCacheAndGetWeatherEvent>(_onClearCacheAndGetWeather);
  }

  Future<void> _onGetWeatherForCity(
    GetWeatherForCityEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    final result = await getWeather.execute(event.cityName);

    result.fold(
      (failure) => emit(WeatherError(failure.message)),
      (weather) => emit(WeatherLoaded(weather)),
    );
  }

  Future<void> _onGetInitialWeather(
    GetInitialWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    final lastWeatherResult = await getLastWeather.execute();

    await lastWeatherResult.fold(
      (failure) async {
        final lastCityResult = await getLastCityName.execute();

        await lastCityResult.fold(
          (failure) async {
            emit(WeatherLoaded(MockWeatherData.getMockWeather()));
          },
          (cityName) async {
            final weatherResult = await getWeather.execute(cityName);

            await weatherResult.fold(
              (failure) async {
                emit(WeatherLoaded(MockWeatherData.getMockWeather()));
              },
              (weather) async {
                emit(WeatherLoaded(weather));
              },
            );
          },
        );
      },
      (weather) async {
        emit(WeatherLoaded(weather));
      },
    );
  }

  Future<void> _onClearCacheAndGetWeather(
    ClearCacheAndGetWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    await localDataSource.clearCache();

    final result = await getWeather.execute(event.cityName);

    result.fold(
      (failure) => emit(WeatherError(failure.message)),
      (weather) => emit(WeatherLoaded(weather)),
    );
  }
}
