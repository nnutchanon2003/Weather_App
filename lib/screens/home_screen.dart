import 'package:flutter/material.dart';

import '/constants/app_colors.dart';
import '/screens/forecast_report_screen.dart';
import '/screens/search_screen.dart';
import '/screens/settings_screen.dart';
import 'weather_screen/weather_screen.dart';
import '/services/api_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;

  final _screens = const [
    WeatherScreen(),
    SearchScreen(),
    ForecastReportScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    ApiHelper.getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,  // สีพื้นหลังหลักของหน้าจอ
      body: _screens[_currentPageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.secondaryBlack,  // สีพื้นหลังของ Navigation Bar
          indicatorColor: AppColors.lightBlue,  // สีของไฮไลต์เมื่อเลือกหน้า
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: AppColors.white),  // สีของข้อความใน Navigation Bar
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentPageIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (index) =>
              setState(() => _currentPageIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: AppColors.grey),  // สีเมื่อไม่ได้เลือก
              selectedIcon: Icon(Icons.home, color: AppColors.white),  // สีเมื่อเลือกแล้ว
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, color: AppColors.grey),
              selectedIcon: Icon(Icons.search, color: AppColors.white),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.wb_sunny_outlined, color: AppColors.grey),
              selectedIcon: Icon(Icons.wb_sunny, color: AppColors.white),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: AppColors.grey),
              selectedIcon: Icon(Icons.settings, color: AppColors.white),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
