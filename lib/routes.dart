import 'package:flutter/material.dart';
import 'main_shell.dart';
import 'screens/splash_screen.dart';

/// Named route constants. Screens not yet built in the current phase point
/// at [MainShell] as a placeholder and are rewired as later phases land.
class Routes {
  static const splash = '/';
  static const shell = '/shell';
  static const detail = '/detail';
  static const booking1 = '/booking1';
  static const booking2 = '/booking2';
  static const booking3 = '/booking3';
  static const ticket = '/ticket';
  static const auth = '/auth';
  static const otp = '/otp';
  static const notifications = '/notifications';
  static const subscription = '/subscription';
  static const plans = '/plans';
  static const payments = '/payments';
  static const myBookings = '/mybookings';
  static const refund = '/refund';
}

final appRoutes = <String, WidgetBuilder>{
  Routes.shell: (_) => const MainShell(),
  Routes.splash: (_) => const SplashScreen(),
  // Wired in later phases:
  Routes.auth: (_) => const Placeholder(),
  Routes.otp: (_) => const Placeholder(),
  Routes.booking1: (_) => const Placeholder(),
  Routes.notifications: (_) => const Placeholder(),
};
