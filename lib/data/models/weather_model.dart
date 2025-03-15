class WeatherModel {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final String cityName;
  final List<WeatherForecast> forecast;
  final double latitude;
  final double longitude;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.cityName,
    required this.forecast,
    required this.latitude,
    required this.longitude,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      cityName: json['name'] as String,
      forecast: [],
      latitude: (json['coord']['lat'] as num).toDouble(),
      longitude: (json['coord']['lon'] as num).toDouble(),
    );
  }
}

class WeatherForecast {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;

  WeatherForecast({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
    );
  }
} 