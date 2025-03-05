# Dynamic Theme Manager 🎨

A Flutter package for dynamic theme management using GetX and SharedPreferences.

## ✨ Features
✅ Toggle between light & dark mode  
✅ Change primary colors dynamically  
✅ Save preferences using SharedPreferences  
✅ Lightweight and easy to integrate

## 📦 Installation
Add the following to your `pubspec.yaml`:
```yaml
dependencies:
  dynamic_theme_manager: ^1.0.0

## 🚀 Usage

1. Initialize Theme Controller

In your main.dart:

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dynamic_theme_manager/dynamic_theme_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: DynamicThemeManager.themeController.lightTheme.value,
      darkTheme: DynamicThemeManager.themeController.darkTheme.value,
      themeMode: DynamicThemeManager.currentThemeMode,
      home: HomeScreen(),
    );
  }
}

2. Toggle Theme Mode

DynamicThemeManager.themeController.toggleTheme();

3. Change Primary Colors Dynamically

DynamicThemeManager.themeController.updateLightTheme(Colors.blue);
DynamicThemeManager.themeController.updateDarkTheme(Colors.deepPurple);


