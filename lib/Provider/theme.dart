import 'package:flutter/material.dart';

class AppThemes {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1E5AA8), // Primary Blue
    scaffoldBackgroundColor: const Color(0xFFFFFFFF), // White Background
    cardColor:  Color(0xFFD9E6F2), // Light Blue for Sidebar & Cards
    // Removed duplicate colorScheme definition
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E5AA8), // Primary Blue
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFFFFFFFF), // White background for drawer
    ),
    iconTheme: const IconThemeData(color: Colors.black), // Black icons
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF1E5AA8), // Primary Blue for buttons
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E5AA8), // Primary Blue
        foregroundColor: Colors.white, // White text
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    dividerColor: Colors.black26, // Subtle dividers
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1E5AA8),
      secondary: Color(0xFF1E2A38),
      onPrimary: Colors.white,
      error: Color(0xFFFF0000), // Red for errors/warnings
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1E5AA8), // Primary Blue
    scaffoldBackgroundColor:
         Color(0xFF121212), // Dark Gray/Black Background
    cardColor:  Color(0xFF1E2A38), // Dark Blue-Gray for Cards/Sidebar
    // Removed duplicate colorScheme definition
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E5AA8), // Primary Blue
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF1E1E1E), // Dark gray background for drawer
    ),
    iconTheme: const IconThemeData(color: Colors.white), // White icons
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF1E5AA8), // Primary Blue for buttons
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E5AA8), // Primary Blue
        foregroundColor: Colors.white, // White text
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white), // White icons
      ),
    ),
    dividerColor: Colors.white24, // Subtle dividers
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1E5AA8),
      secondary: Color(0xFF424242),
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      error: Color(0xFFFF5252), // Soft Red for errors/warnings
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = AppThemes.lightTheme;
  bool _isDarkMode = false;

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    notifyListeners();
  }
}
