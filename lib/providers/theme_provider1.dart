// // import 'package:flutter/material.dart';

// // class ThemeProvider extends ChangeNotifier {
// //   ThemeMode _themeMode = ThemeMode.system;
// //   Locale _locale = const Locale('fr');

// //   ThemeMode get themeMode => _themeMode;
// //   Locale get currentLocale => _locale;

// //   void toggleTheme(bool isDark) {
// //     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
// //     notifyListeners();
// //   }

// //   void changeLocale(Locale locale) {
// //     _locale = locale;
// //     notifyListeners();
// //   }
// // }
// // import 'package:flutter/material.dart';

// // class ThemeProvider extends ChangeNotifier {
// //   ThemeMode _themeMode = ThemeMode.system;

// //   ThemeMode get themeMode => _themeMode;

// //   void toggleTheme(bool isDark) {
// //     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
// //     notifyListeners();
// //   }
// // }
// // lib/providers/theme_provider.dart
// // import 'package:flutter/material.dart';
// // import 'package:easy_localization/easy_localization.dart';

// // class ThemeProvider extends ChangeNotifier {
// //   ThemeMode _themeMode = ThemeMode.light;
// //   ThemeMode get themeMode => _themeMode;

// //   Locale? _locale;
// //   Locale? get locale => _locale;

// //   void toggleTheme(bool isDark) {
// //     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
// //     notifyListeners();
// //   }

// //   // 🔹 Méthode pour changer la langue
// //   void changeLocale(BuildContext context, Locale newLocale) {
// //     _locale = newLocale;
// //     context.setLocale(newLocale); // EasyLocalization change la langue
// //     notifyListeners(); // pour forcer rebuild si nécessaire
// //   }
// // }
// // lib/providers/theme_provider.dart
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';

// class ThemeProvider extends ChangeNotifier {
//   ThemeMode _themeMode = ThemeMode.light;
//   ThemeMode get themeMode => _themeMode;

//   Locale? _locale;
//   Locale? get locale => _locale;

//   // 🔹 Nouveau getter pour simplifier l'accès dans main.dart
//   bool get isDarkMode => _themeMode == ThemeMode.dark;

//   void toggleTheme(bool isDark) {
//     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }

//   // Méthode pour changer la langue
//   void changeLocale(BuildContext context, Locale newLocale) {
//     _locale = newLocale;
//     context.setLocale(newLocale); // EasyLocalization change la langue
//     notifyListeners(); // pour forcer rebuild si nécessaire
//   }
// }
