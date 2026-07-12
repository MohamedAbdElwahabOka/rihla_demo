import 'package:flutter/material.dart';

class RihlaColors {
  static const seaBlue = Color(0xFF0077B6);
  static const seaBlueDark = Color(0xFF023E58);
  static const gold = Color(0xFFE8B23A);
  static const bg = Color(0xFFF5F8FA);
}

ThemeData buildRihlaTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: RihlaColors.seaBlue,
      primary: RihlaColors.seaBlue,
      secondary: RihlaColors.gold,
    ),
    scaffoldBackgroundColor: RihlaColors.bg,
  );
  return base.copyWith(
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: RihlaColors.seaBlue,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: RihlaColors.seaBlue.withValues(alpha: 0.15),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? RihlaColors.seaBlueDark : Colors.grey,
        );
      }),
    ),
  );
}
