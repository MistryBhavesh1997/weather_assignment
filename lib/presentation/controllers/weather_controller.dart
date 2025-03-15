import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/weather_model.dart';
import '../../data/services/weather_service.dart';

class WeatherController extends GetxController {
  final WeatherService _weatherService = WeatherService();
  
  final Rx<WeatherModel?> currentWeather = Rx<WeatherModel?>(null);
  final RxList<WeatherForecast> forecast = <WeatherForecast>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isCelsius = true.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocationWeather();
  }

  Future<void> getCurrentLocationWeather() async {
    try {
      isLoading.value = true;
      isError.value = false;
      
      final position = await _determinePosition();
      await Future.wait([
        _fetchCurrentWeather(position.latitude, position.longitude),
        _fetchForecast(position.latitude, position.longitude),
      ]);
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getWeatherByCity(String city) async {
    try {
      isLoading.value = true;
      isError.value = false;
      
      currentWeather.value = await _weatherService.getWeatherByCity(city);
      // After getting current weather, fetch forecast for the same city
      if (currentWeather.value != null) {
        await _fetchForecast(
          currentWeather.value!.latitude,
          currentWeather.value!.longitude,
        );
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchCurrentWeather(double lat, double lon) async {
    currentWeather.value = await _weatherService.getCurrentWeather(lat, lon);
  }

  Future<void> _fetchForecast(double lat, double lon) async {
    forecast.value = await _weatherService.getForecast(lat, lon);
  }

  void toggleTemperatureUnit() {
    isCelsius.value = !isCelsius.value;
  }

  double convertTemperature(double celsius) {
    if (isCelsius.value) return celsius;
    return (celsius * 9/5) + 32;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    print("permission==== ${permission}");
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
} 