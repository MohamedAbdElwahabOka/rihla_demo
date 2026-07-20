import 'package:flutter/material.dart';

/// Rihla design system — "Red Sea Coastal Premium".
///
/// A cohesive palette anchored on deep teal-navy ink, azure→lagoon sea
/// gradients, and warm gold/coral sunset accents. The legacy names
/// (`seaBlue`, `seaBlueDark`, `gold`, `bg`) are preserved so existing screens
/// keep compiling while everything migrates onto the richer tokens below.
class RihlaColors {
  // --- Brand / sea ---
  static const seaBlue = Color(0xFF0077B6); // primary
  static const seaBlueDark = Color(0xFF023E58); // deep ink-teal
  static const lagoon = Color(0xFF00B4D8); // bright cyan highlight
  static const seaTint = Color(0xFFE3F1F8); // faint sea wash for fills

  // --- Sunset accents ---
  static const gold = Color(0xFFE8B23A);
  static const coral = Color(0xFFF3705A); // warm CTA / discount accent
  static const goldTint = Color(0xFFFBF0D8);

  // --- Neutrals ---
  static const bg = Color(0xFFF3F7FA); // airy cool near-white
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0B2A38); // primary text (deep teal-black)
  static const inkMuted = Color(0xFF5C7480); // secondary text
  static const inkFaint = Color(0xFF93A7B0); // tertiary / hints
  static const hairline = Color(0xFFE4ECF1); // borders / dividers

  // --- On-brand ---
  /// Text/icon color for content placed on top of a brand-colored surface
  /// (sea/sunset gradients, filled buttons, photography) — named so those
  /// call sites resolve through a token instead of a raw `Colors.white`.
  static const onBrand = Colors.white;

  // --- Gradients ---
  /// Hero / branding wash — deep sea to bright lagoon.
  static const seaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [seaBlueDark, seaBlue, lagoon],
  );

  /// Warm premium / badge wash — gold to coral.
  static const sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold, coral],
  );
}

/// Reusable soft shadow stacks. Elevation in this app is expressed with
/// layered low-opacity shadows rather than Material's default hard elevation.
class RihlaShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: RihlaColors.seaBlueDark.withValues(alpha: 0.06),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: RihlaColors.seaBlueDark.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get soft => [
        BoxShadow(
          color: RihlaColors.seaBlueDark.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get raised => [
        BoxShadow(
          color: RihlaColors.seaBlueDark.withValues(alpha: 0.16),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];
}

/// Spacing + radius scale, so screens compose from shared rhythm.
class RihlaSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  static const radiusSm = 10.0;
  static const radius = 16.0;
  static const radiusLg = 22.0;
  static const radiusPill = 100.0;
}

ThemeData buildRihlaTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: RihlaColors.seaBlue,
    primary: RihlaColors.seaBlue,
    secondary: RihlaColors.gold,
    surface: RihlaColors.surface,
    onSurface: RihlaColors.ink,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: RihlaColors.bg,
    splashFactory: InkSparkle.splashFactory,
  );

  // Refined native type scale: heavier, tighter display weights for a
  // characterful feel; comfortable body line-height; muted-ink defaults.
  final text = base.textTheme
      .apply(displayColor: RihlaColors.ink, bodyColor: RihlaColors.ink)
      .copyWith(
        displaySmall: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.8, color: RihlaColors.ink),
        headlineMedium: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.6, color: RihlaColors.ink),
        headlineSmall: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.4, color: RihlaColors.ink),
        titleLarge: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.3, color: RihlaColors.ink),
        titleMedium: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.2, color: RihlaColors.ink),
        titleSmall: const TextStyle(fontWeight: FontWeight.w600, color: RihlaColors.ink),
        bodyLarge: const TextStyle(height: 1.5, color: RihlaColors.ink),
        bodyMedium: const TextStyle(height: 1.5, color: RihlaColors.inkMuted),
        labelLarge: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.1),
      );

  return base.copyWith(
    textTheme: text,
    dividerTheme: const DividerThemeData(color: RihlaColors.hairline, thickness: 1, space: 1),
    cardTheme: CardThemeData(
      elevation: 4,
      color: RihlaColors.surface,
      surfaceTintColor: Colors.transparent,
      shadowColor: RihlaColors.seaBlueDark.withValues(alpha: 0.28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RihlaSpace.radius)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: RihlaColors.seaBlueDark,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: RihlaColors.seaBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RihlaSpace.radius)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: RihlaColors.seaBlueDark,
        minimumSize: const Size.fromHeight(54),
        side: const BorderSide(color: RihlaColors.hairline, width: 1.5),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RihlaSpace.radius)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: RihlaColors.seaBlue,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: RihlaColors.surface,
      selectedColor: RihlaColors.seaBlue,
      checkmarkColor: Colors.white,
      side: const BorderSide(color: RihlaColors.hairline),
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: RihlaColors.ink),
      secondaryLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RihlaSpace.radiusPill)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      showCheckmark: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: RihlaColors.surface,
      hintStyle: const TextStyle(color: RihlaColors.inkFaint),
      prefixIconColor: RihlaColors.inkMuted,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RihlaSpace.radius),
        borderSide: const BorderSide(color: RihlaColors.hairline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RihlaSpace.radius),
        borderSide: const BorderSide(color: RihlaColors.hairline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RihlaSpace.radius),
        borderSide: const BorderSide(color: RihlaColors.seaBlue, width: 1.6),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: RihlaColors.ink,
      contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RihlaSpace.radius)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: RihlaColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RihlaSpace.radiusLg)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: RihlaColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RihlaSpace.radiusLg)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: RihlaColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 68,
      indicatorColor: RihlaColors.seaTint,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? RihlaColors.seaBlueDark : RihlaColors.inkFaint,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(color: selected ? RihlaColors.seaBlue : RihlaColors.inkFaint);
      }),
    ),
  );
}
