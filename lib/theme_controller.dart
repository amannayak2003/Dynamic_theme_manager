library dynamic_theme_manager;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String themeKey = "selected_theme";
  static const String lightColorKey = "light_primary_color";
  static const String darkColorKey = "dark_primary_color";

  late SharedPreferences _prefs;
  var isDarkMode = false.obs;
  var lightPrimaryColor = Colors.blue.obs;
  var darkPrimaryColor = Colors.deepPurple.obs;

  var lightTheme = ThemeData.light().obs;
  var darkTheme = ThemeData.dark().obs;

  final bool isDynamic;

  ThemeController({required this.isDynamic});

  @override
  void onInit() async {
    _prefs = await SharedPreferences.getInstance();
    isDarkMode.value = _prefs.getBool(themeKey) ?? false;

    if (isDynamic) {
      int? storedLightColor = _prefs.getInt(lightColorKey);
      int? storedDarkColor = _prefs.getInt(darkColorKey);

      if (storedLightColor != null) {
        lightPrimaryColor.value = createMaterialColor(Color(storedLightColor));
        updateLightTheme(lightPrimaryColor.value);
      }
      if (storedDarkColor != null) {
        darkPrimaryColor.value = createMaterialColor(Color(storedDarkColor));
        updateDarkTheme(darkPrimaryColor.value);
      }
    }

    super.onInit();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _prefs.setBool(themeKey, isDarkMode.value);

    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    // Apply the correct theme after switching
    Get.changeTheme(isDarkMode.value ? darkTheme.value : lightTheme.value);
  }

  void updateLightTheme(Color color) {
    if (!isDynamic) return;

    lightPrimaryColor.value = createMaterialColor(color);
    lightTheme.value = ThemeData(
      colorScheme: ColorScheme.light(primary: color),
      primarySwatch: createMaterialColor(color),
      brightness: Brightness.light,
      // scaffoldBackgroundColor: color,
      appBarTheme: AppBarTheme(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );

    _prefs.setInt(lightColorKey, color.value);

    // Only update the theme if we're in light mode
    if (!isDarkMode.value) {
      Get.changeTheme(lightTheme.value);
    }
  }

  void updateDarkTheme(Color color) {
    if (!isDynamic) return; // Prevent changes if dynamic theme is disabled

    darkPrimaryColor.value = createMaterialColor(color);
    darkTheme.value = ThemeData(
      colorScheme: ColorScheme.dark(primary: color),
      primarySwatch: createMaterialColor(color),
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );

    _prefs.setInt(darkColorKey, color.value);

    // Only update the theme if we're in dark mode
    if (isDarkMode.value) {
      Get.changeTheme(darkTheme.value);
    }
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class DynamicThemeManager {
  static late ThemeController themeController;

  static void initialize({required bool isDynamic}) {
    themeController = Get.put(ThemeController(isDynamic: isDynamic));
  }

  static ThemeMode get currentThemeMode =>
      themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  static void toggleTheme() => themeController.toggleTheme();

  static void updateLightTheme(Color color) =>
      themeController.updateLightTheme(color);

  static void updateDarkTheme(Color color) =>
      themeController.updateDarkTheme(color);
}
