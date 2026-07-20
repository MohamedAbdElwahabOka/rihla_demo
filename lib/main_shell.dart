import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'main.dart';
import 'theme.dart';
import 'screens/explore_screen.dart';
import 'screens/home_screen.dart';
import 'screens/my_bookings_screen.dart';
import 'screens/profile_screen.dart';

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

    // Not const: each of these reads mutable global state (userSubscription,
    // currentUser, bookings) that can change on a different pushed screen
    // (e.g. purchasing a plan). A const instance here would be identical
    // across rebuilds, so Flutter would skip re-visiting it entirely and
    // this tab would keep showing stale data after switching back to it.
    final tabs = [
      HomeScreen(onSearchTap: () => setState(() => _tab = 1)),
      ExploreScreen(),
      MyBookingsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(gradient: RihlaColors.seaGradient),
        ),
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: RihlaColors.onBrand.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.sailing, size: 18, color: RihlaColors.onBrand),
            ),
            const SizedBox(width: 10),
            Text(l10n.appName),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () => _cycleLocale(context),
              style: TextButton.styleFrom(
                backgroundColor: RihlaColors.onBrand.withValues(alpha: 0.18),
                foregroundColor: RihlaColors.onBrand,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, size: 15, color: RihlaColors.onBrand),
                  const SizedBox(width: 5),
                  Text(locale, style: const TextStyle(color: RihlaColors.onBrand, fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
            ),
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
