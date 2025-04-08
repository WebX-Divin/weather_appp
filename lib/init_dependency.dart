import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_appp/core/network/network_info.dart';
import 'package:weather_appp/data/datasources/weather_local_datasource.dart';
import 'package:weather_appp/data/datasources/weather_remote_datasource.dart';
import 'package:weather_appp/data/repositories/weather_repository_impl.dart';
import 'package:weather_appp/domain/repositories/weather_repository.dart';
import 'package:weather_appp/domain/usecases/get_last_weather.dart';
import 'package:weather_appp/domain/usecases/get_weather.dart';
import 'package:weather_appp/presentation/bloc/weather_bloc_bloc.dart';
import 'package:http/http.dart' as http;
import 'domain/usecases/get_last_city_name.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetWeather(sl()));
  sl.registerLazySingleton(() => GetLastWeather(sl()));
  sl.registerLazySingleton(() => GetLastCityName(sl()));

  // Bloc
  sl.registerFactory(() => WeatherBloc(
        getWeather: sl(),
        getLastWeather: sl(),
        getLastCityName: sl(),
        localDataSource: sl(),
      ));
}
