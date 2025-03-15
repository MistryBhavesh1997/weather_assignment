import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const WeatherSearchBar({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: TextField(
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          hintText: 'Search city...',
          hintStyle: TextStyle(
            color: Colors.white70,
            fontSize: 16.sp,
          ),
          border: InputBorder.none,
          icon: const Icon(
            Icons.search,
            color: Colors.white70,
          ),
        ),
        onSubmitted: onSearch,
      ),
    );
  }
} 