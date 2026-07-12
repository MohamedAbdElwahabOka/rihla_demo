import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'theme.dart';
import 'routes.dart';

void main() => runApp(const RihlaApp());

/// Root widget. Owns the active [Locale] so any screen can switch the app
/// language via `RihlaApp.of(context).setLocale(...)` — this is the only
/// piece of state that lives above the route tree (SRS: EN/DE/RU switching).
class RihlaApp extends StatefulWidget {
  const RihlaApp({super.key});

  // ignore: library_private_types_in_public_api
  static _RihlaAppState of(BuildContext context) => context.findAncestorStateOfType<_RihlaAppState>()!;

  @override
  State<RihlaApp> createState() => _RihlaAppState();
}

class _RihlaAppState extends State<RihlaApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) => setState(() => _locale = locale);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rihla',
      debugShowCheckedModeBanner: false,
      theme: buildRihlaTheme(),
      locale: _locale,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: Routes.splash,
      routes: appRoutes,
    );
  }
}
