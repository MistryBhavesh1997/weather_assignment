import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/weather_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WeatherInfoCard extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback onUnitToggle;
  final bool isCelsius;
  final double Function(double) convertTemp;

  const WeatherInfoCard({
    Key? key,
    required this.weather,
    required this.onUnitToggle,
    required this.isCelsius,
    required this.convertTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weather.cityName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  isCelsius ? Icons.thermostat : Icons.thermostat_auto,
                  color: Colors.white,
                ),
                onPressed: onUnitToggle,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: 'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                width: 100.w,
                height: 100.w,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Column(
                children: [
                  Text(
                    '${convertTemp(weather.temperature).toStringAsFixed(1)}°${isCelsius ? 'C' : 'F'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    weather.description.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(
                Icons.water_drop,
                '${weather.humidity}%',
                'Humidity',
              ),
              _buildWeatherDetail(
                Icons.air,
                '${weather.windSpeed} m/s',
                'Wind',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24.w),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
} 