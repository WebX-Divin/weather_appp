import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather_appp/core/utils/theme_provider.dart';
import 'package:weather_appp/presentation/bloc/weather_bloc_bloc.dart';
import 'package:weather_appp/presentation/pages/widgets/city_auto_complete_search.dart';
import 'package:weather_appp/presentation/pages/widgets/current_weather_widget.dart';
import 'package:weather_appp/presentation/pages/widgets/forecast_widget.dart';
import 'package:weather_appp/presentation/pages/widgets/weather_shimmer.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  void _getWeather() {
    if (_cityController.text.isNotEmpty) {
      BlocProvider.of<WeatherBloc>(context)
          .add(GetWeatherForCityEvent(_cityController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar with Theme Toggle
                  _buildAppBar(context),

                  // City search
                  _buildSearchBar(context),

                  // Expanded area for weather content
                  Expanded(
                    child: _buildWeatherContent(state, context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Weather App',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          // Theme toggle button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.wb_sunny
                      : Icons.nightlight_round,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                tooltip: themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: CityAutocompleteSearch(
        controller: _cityController,
        onSelected: (city) {
          _cityController.text = city;
          _getWeather();
        },
        onSearch: _getWeather,
      ),
    );
  }

  Widget _buildWeatherContent(WeatherState state, BuildContext context) {
    if (state is WeatherLoading) {
      return const Center(
        child: WeatherShimmerLoading(),
      );
    } else if (state is WeatherLoaded) {
      return PageView(
        controller: _pageController,
        children: [
          // First page - current weather
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CurrentWeatherWidget(weather: state.weather),
                const SizedBox(height: 16),
                ForecastWidget(forecast: state.weather.forecast),
              ],
            ),
          ),
          // Additional pages could be added here
        ],
      );
    } else if (state is WeatherError) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _getWeather,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter a city name to get started',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
