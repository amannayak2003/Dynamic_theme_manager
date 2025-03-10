import 'package:dynamic_theme_manager/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DynamicThemeManager.initialize(
      isDynamic: true); // Set false for static theming
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          title: 'Dynamic Theme Example',
          debugShowCheckedModeBanner: false,
          theme: DynamicThemeManager.themeController.lightTheme.value,
          darkTheme: DynamicThemeManager.themeController.darkTheme.value,
          themeMode: DynamicThemeManager.currentThemeMode,
          home: HomeScreen(),
        ));
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dynamic Theme Manager")),
      body: Obx(() => Container(
            width: double.infinity,
            height: double.infinity,
            color: DynamicThemeManager.themeController.isDarkMode.value
                ? DynamicThemeManager.themeController.darkPrimaryColor.value
                    .withOpacity(0.2)
                : DynamicThemeManager.themeController.lightPrimaryColor.value
                    .withOpacity(0.2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    value: DynamicThemeManager.themeController.isDarkMode.value,
                    onChanged: (value) =>
                        DynamicThemeManager.themeController.toggleTheme(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      DynamicThemeManager.updateLightTheme(Colors.blue);
                    },
                    child: const Text("Set Light Theme"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      DynamicThemeManager.updateDarkTheme(Colors.redAccent);
                    },
                    child: const Text("Set Dark Theme"),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
