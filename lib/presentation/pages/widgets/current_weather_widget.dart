import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/weather.dart';
import '../../../presentation/bloc/weather_bloc_bloc.dart';
import 'weather_condition_icon.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final Weather weather;

  const CurrentWeatherWidget({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(isDarkMode ? 0.7 : 0.8),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildMainInfo(context),
              const Divider(height: 24),
              _buildDetailsGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, d MMMM');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  weather.cityName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              dateFormat.format(now),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          onPressed: () {
            BlocProvider.of<WeatherBloc>(context)
                .add(ClearCacheAndGetWeatherEvent('Salem'));
          },
          tooltip: 'Refresh with Current weather',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildMainInfo(BuildContext context) {
    final tempF = (weather.temperature * 9 / 5) + 32;
    final feelsLikeF = ((weather.temperature - 1.5) * 9 / 5) + 32;

    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 40;

    final tempFontSize = availableWidth < 300 ? 44.0 : 60.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '${tempF.toStringAsFixed(1)}°F',
                  style: TextStyle(
                    fontSize: tempFontSize,
                    fontWeight: FontWeight.bold,
                    height: 0.9,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Feels like ${feelsLikeF.toStringAsFixed(1)}°F',
                style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WeatherConditionIcon(
                condition: weather.condition,
                size: 60,
              ),
              const SizedBox(height: 4),
              Text(
                weather.condition,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .secondaryContainer
            .withOpacity(isDarkMode ? 0.2 : 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12), // Reduced padding
            child: Row(
              children: [
                Expanded(
                  child: _buildDetailCard(
                    context,
                    Icons.water_drop_outlined,
                    'Humidity',
                    '${weather.humidity}%',
                  ),
                ),
                const SizedBox(width: 10), // Reduced spacing
                Expanded(
                  child: _buildDetailCard(
                    context,
                    Icons.air,
                    'Wind',
                    '${weather.windSpeed} m/s',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 12, right: 12, bottom: 12), // Reduced padding
            child: Row(
              children: [
                Expanded(
                  child: _buildDetailCard(
                    context,
                    Icons.wb_sunny_outlined,
                    'Sunrise',
                    timeFormat.format(weather.sunrise),
                  ),
                ),
                const SizedBox(width: 10), // Reduced spacing
                Expanded(
                  child: _buildDetailCard(
                    context,
                    Icons.nightlight_outlined,
                    'Sunset',
                    timeFormat.format(weather.sunset),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Card(
      elevation: 1, // Reduced elevation
      margin: EdgeInsets.zero, // Remove margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16, // Smaller icon
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 6), // Reduced spacing
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12, // Smaller font size
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6), // Reduced spacing
            Text(
              value,
              style: TextStyle(
                fontSize: 14, // Smaller font size
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
