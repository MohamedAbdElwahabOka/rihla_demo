import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'main.dart';
import 'screens/home_screen.dart';

/// Hosts the 4-tab bottom navigation (Home, Explore, Bookings, Profile —
/// FR-025). Detail/booking/auth screens push on top of this shell.
/// Wave 2/3/4 replace the placeholder tab bodies with the real screens.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  void _cycleLocale(BuildContext context) {
    const order = [Locale('en'), Locale('de'), Locale('ru')];
    final current = Localizations.localeOf(context);
    final next = order[(order.indexWhere((l) => l.languageCode == current.languageCode) + 1) % order.length];
    RihlaApp.of(context).setLocale(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode.toUpperCase();

    final tabs = [
      HomeScreen(onSearchTap: () => setState(() => _tab = 1)),
      Center(child: Text(l10n.navExplore)),
      Center(child: Text(l10n.navBookings)),
      Center(child: Text(l10n.navProfile)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          TextButton(
            onPressed: () => _cycleLocale(context),
            child: Text(locale, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: IndexedStack(index: _tab, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: l10n.navHome),
          NavigationDestination(icon: const Icon(Icons.explore_outlined), selectedIcon: const Icon(Icons.explore), label: l10n.navExplore),
          NavigationDestination(icon: const Icon(Icons.confirmation_number_outlined), selectedIcon: const Icon(Icons.confirmation_number), label: l10n.navBookings),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: l10n.navProfile),
        ],
      ),
    );
  }
}
