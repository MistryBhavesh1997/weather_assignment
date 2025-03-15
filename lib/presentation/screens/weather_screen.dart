import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/weather_controller.dart';
import '../widgets/weather_info_card.dart';
import '../widgets/forecast_list.dart';
import '../widgets/search_bar.dart';

class WeatherScreen extends GetView<WeatherController> {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade900,
              ],
            ),
          ),
          child: Obx(
            () => RefreshIndicator(
              onRefresh: controller.getCurrentLocationWeather,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          WeatherSearchBar(
                            onSearch: controller.getWeatherByCity,
                          ),
                          SizedBox(height: 20.h),
                          if (controller.isLoading.value)
                            const CircularProgressIndicator(color: Colors.white)
                          else if (controller.isError.value)
                            Text(
                              controller.errorMessage.value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            )
                          else if (controller.currentWeather.value != null)
                            Column(
                              children: [
                                WeatherInfoCard(
                                  weather: controller.currentWeather.value!,
                                  onUnitToggle: controller.toggleTemperatureUnit,
                                  isCelsius: controller.isCelsius.value,
                                  convertTemp: controller.convertTemperature,
                                ),
                                SizedBox(height: 20.h),
                                if (controller.forecast.isNotEmpty)
                                  ForecastList(
                                    forecast: controller.forecast,
                                    isCelsius: controller.isCelsius.value,
                                    convertTemp: controller.convertTemperature,
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 