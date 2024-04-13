// ** THANKS TO https://github.com/SashaKryzh/flutter_custom_theme_example.git
import 'package:flutter/material.dart';
import 'package:demo/components/theme/app_colors_extension.dart';
import 'package:demo/components/theme/app_typography.dart';
import 'package:demo/components/theme/app_text_theme_extension.dart';

/// Simple Flutter app theme with `ChangeNotifier` and `ThemeExtension`.
/// With support for changing between light/dark mode.
///
/// You can also register it in `get_it` or any other package you use.
class AppTheme with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  //
  // Light theme
  //

  static final light = () {
    final defaultTheme = ThemeData.light();

    return defaultTheme.copyWith(
      textTheme: defaultTheme.textTheme.copyWith(
        // Default text style for Text widget.
        bodyMedium: AppTypography.body1.copyWith(color: Colors.black),
      ),
      extensions: [
        _lightAppColors,
        _lightTextTheme,
      ],
    );
  }();

  static final _lightAppColors = AppColorsExtension(
    primary: const Color(0xff013F27),
    onPrimary: const Color(0xffD9D9D9),
    secondary: const Color(0xff87AE8F),
    onSecondary: const Color(0xff333333),
    error: const Color(0xffb00020),
    onError: Colors.white,
    background: const Color(0xffB4E4C4),
    onBackground: const Color(0xff013F27),
    surface: Colors.white,
    onSurface: Colors.black,
  );

  static final _lightTextTheme = SimpleAppTextThemeExtension(
    body1: AppTypography.body1.copyWith(color: _lightAppColors.onBackground),
    h1: AppTypography.h1.copyWith(color: const Color(0xff013F27)),
  );

  //
  // Dark theme
  //

  static final dark = () {
    final defaultTheme = ThemeData.dark();

    return defaultTheme.copyWith(
      textTheme: defaultTheme.textTheme.copyWith(
        // Default text style for Text widget.
        bodyMedium: AppTypography.body1.copyWith(color: Colors.white),
      ),
      extensions: [
        _darkAppColors,
        _darkTextTheme,
      ],
    );
  }();

  static final _darkAppColors = AppColorsExtension(
    primary: const Color(0xffbb86fc),
    onPrimary: Colors.black,
    secondary: const Color(0xff03dac6),
    onSecondary: Colors.black,
    error: const Color(0xffcf6679),
    onError: Colors.black,
    background: const Color(0xff121212),
    onBackground: Colors.white,
    surface: const Color(0xff121212),
    onSurface: Colors.white,
  );

  static final _darkTextTheme = SimpleAppTextThemeExtension(
    body1: AppTypography.body1.copyWith(color: _darkAppColors.onBackground),
    h1: AppTypography.h1.copyWith(color: Colors.white),
  );
}

/// Here you should define getters for your `ThemeExtension`s.
///
/// Never use `Theme.of(context).extension<MyColors>()!`
/// how they do it in the [official documentation](https://api.flutter.dev/flutter/material/ThemeExtension-class.html),
/// because it's not safe. Always create a getter for your `ThemeExtension` and use it instead.
///
/// Usage example: `Theme.of(context).appColors`.
extension AppThemeExtension on ThemeData {
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? AppTheme._lightAppColors;

  SimpleAppTextThemeExtension get appTextTheme =>
      extension<SimpleAppTextThemeExtension>() ?? AppTheme._lightTextTheme;
}

/// A more convenient way to get `ThemeData` from the `BuildContext`.
///
/// Usage example: `context.theme`.
extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}