import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/weather_model.dart';
import '../../core/network/dio_client.dart';

class WeatherService {
  final Dio _dio = DioClient.dio;

  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'units': 'metric',
        },
      );
      log("weather response $response");

      return WeatherModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<WeatherForecast>> getForecast(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'units': 'metric',
        },
      );
      log("forecast response $response");
      final List<dynamic> list = response.data['list'];
      return list.map((item) => WeatherForecast.fromJson(item)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<WeatherModel> getWeatherByCity(String city) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'q': city,
          'units': 'metric',
        },
      );
      return WeatherModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timed out');
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 404) {
            return Exception('City not found');
          }
          return Exception('Server error');
        case DioExceptionType.connectionError:
          return Exception('No internet connection');
        default:
          return Exception('Something went wrong');
      }
    }
    return Exception('Something went wrong');
  }
} 