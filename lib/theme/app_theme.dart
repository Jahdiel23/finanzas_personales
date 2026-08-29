import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor =
      Color(0xFF2563EB);

  static const Color backgroundColor =
      Color(0xFFF5F7FB);

  static const Color cardColor =
      Colors.white;

  static const Color textColor =
      Color(0xFF1F2937);

  static ThemeData get lightTheme {
    final colorScheme =
        ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,

      colorScheme: colorScheme,

      scaffoldBackgroundColor:
          backgroundColor,

      fontFamily: null,

      appBarTheme: const AppBarTheme(
        backgroundColor:
            backgroundColor,
        foregroundColor:
            textColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 22,
          fontWeight:
              FontWeight.bold,
        ),
      ),

      cardTheme: CardTheme(
        color: cardColor,
        elevation: 1,
        margin:
            EdgeInsets.zero,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),
      ),

      inputDecorationTheme:
          InputDecorationTheme(
        filled: true,
        fillColor:
            Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFD1D5DB),
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFD1D5DB),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                primaryColor,
            width: 2,
          ),
        ),
        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                Colors.red,
          ),
        ),
        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                Colors.red,
            width: 2,
          ),
        ),
      ),

      navigationBarTheme:
          NavigationBarThemeData(
        height: 72,
        backgroundColor:
            Colors.white,
        indicatorColor:
            const Color(
          0xFFDCE8FF,
        ),
        labelTextStyle:
            MaterialStateProperty
                .resolveWith<TextStyle>(
          (states) {
            if (states.contains(
              MaterialState.selected,
            )) {
              return const TextStyle(
                fontWeight:
                    FontWeight.bold,
                color:
                    primaryColor,
              );
            }

            return const TextStyle(
              color:
                  Color(0xFF6B7280),
            );
          },
        ),
      ),

      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        backgroundColor:
            primaryColor,
        foregroundColor:
            Colors.white,
      ),

      filledButtonTheme:
          FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
          backgroundColor:
              primaryColor,
          foregroundColor:
              Colors.white,
          minimumSize:
              const Size(
            0,
            50,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          textStyle:
              const TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),

      elevatedButtonTheme:
          ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              primaryColor,
          foregroundColor:
              Colors.white,
          minimumSize:
              const Size(
            0,
            50,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),

      outlinedButtonTheme:
          OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
          minimumSize:
              const Size(
            0,
            50,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),

      snackBarTheme:
          SnackBarThemeData(
        behavior:
            SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),
      ),

      dividerTheme:
          const DividerThemeData(
        color:
            Color(0xFFE5E7EB),
        thickness: 1,
      ),

      textTheme:
          const TextTheme(
        headlineSmall:
            TextStyle(
          color: textColor,
          fontWeight:
              FontWeight.bold,
        ),
        titleLarge:
            TextStyle(
          color: textColor,
          fontWeight:
              FontWeight.bold,
        ),
        titleMedium:
            TextStyle(
          color: textColor,
          fontWeight:
              FontWeight.w600,
        ),
        bodyLarge:
            TextStyle(
          color: textColor,
        ),
        bodyMedium:
            TextStyle(
          color:
              Color(0xFF4B5563),
        ),
      ),
    );
  }
}