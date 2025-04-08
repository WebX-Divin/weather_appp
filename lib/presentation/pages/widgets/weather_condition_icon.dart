import 'package:flutter/material.dart';

class WeatherConditionIcon extends StatelessWidget {
  final String condition;
  final double size;

  const WeatherConditionIcon({
    super.key,
    required this.condition,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;

    switch (condition) {
      case 'Clear':
        iconData = Icons.wb_sunny;
        break;
      case 'Clouds':
        iconData = Icons.cloud;
        break;
      case 'Rain':
        iconData = Icons.grain;
        break;
      case 'Snow':
        iconData = Icons.ac_unit;
        break;
      case 'Thunderstorm':
        iconData = Icons.flash_on;
        break;
      case 'Drizzle':
        iconData = Icons.grain;
        break;
      case 'Mist':
      case 'Fog':
        iconData = Icons.cloud;
        break;
      default:
        iconData = Icons.wb_sunny;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getColorForCondition(condition, context).withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: size * 0.6,
        color: _getColorForCondition(condition, context),
      ),
    );
  }

  Color _getColorForCondition(String condition, BuildContext context) {
    switch (condition) {
      case 'Clear':
        return Colors.orange;
      case 'Clouds':
        return Colors.blueGrey;
      case 'Rain':
        return Colors.blue;
      case 'Snow':
        return Colors.lightBlue;
      case 'Thunderstorm':
        return Colors.deepPurple;
      case 'Drizzle':
        return Colors.lightBlue;
      case 'Mist':
      case 'Fog':
        return Colors.grey;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}
