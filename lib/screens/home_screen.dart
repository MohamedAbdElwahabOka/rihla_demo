import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/animated_favorite_icon.dart';
import '../widgets/fade_in.dart';
import '../widgets/glass_panel.dart';
import '../widgets/local_image.dart';
import '../widgets/price_tag.dart';
import '../widgets/rihla_badge.dart';
import '../widgets/sign_in_prompt.dart';

/// S1 — Home (FR-010-024). Hosted as the Home tab body in [MainShell].
class HomeScreen extends StatefulWidget {
  final VoidCallback onSearchTap;
  const HomeScreen({super.key, required this.onSearchTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> _favoriteIds = {};

  void _toggleFavorite(String id) {
    if (isGuest) {
      promptSignIn(context);
      return;
    }
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
  }

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 18) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final unreadCount = notifications.where((n) => n.unread).length;
    final featured = experiences.where((e) => e.badge != null).toList();
    final popular = [...experiences]..sort((a, b) => b.rating.compareTo(a.rating));

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          FadeInUp(child: _Header(greeting: _greeting(l10n), unreadCount: unreadCount)),
          const SizedBox(height: 16),
          FadeInUp(delay: const Duration(milliseconds: 60), child: _SearchBar(onTap: widget.onSearchTap, hint: l10n.searchHint)),
          const SizedBox(height: 18),
          FadeInUp(
            delay: const Duration(milliseconds: 120),
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: homeCategories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) => ActionChip(
                  label: Text(homeCategories[i]),
                  onPressed: widget.onSearchTap,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(delay: const Duration(milliseconds: 160), child: _SectionHeader(title: l10n.featured)),
          FadeInUp(
            delay: const Duration(milliseconds: 160),
            child: SizedBox(
              height: 232,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, i) => _FeaturedCard(experience: featured[i]),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(delay: const Duration(milliseconds: 200), child: _SectionHeader(title: l10n.popular)),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: SizedBox(
              height: 222,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: popular.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, i) => _PopularCard(
                  experience: popular[i],
                  isFavorite: _favoriteIds.contains(popular[i].id),
                  onFavoriteToggle: () => _toggleFavorite(popular[i].id),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(delay: const Duration(milliseconds: 240), child: _SectionHeader(title: l10n.restaurants)),
          FadeInUp(
            delay: const Duration(milliseconds: 240),
            child: SizedBox(
              height: 196,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: restaurants.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, i) => _RestaurantCard(restaurant: restaurants[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String greeting;
  final int unreadCount;
  const _Header({required this.greeting, required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, ${currentUser.firstName}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: RihlaColors.seaTint,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wb_sunny_rounded, size: 15, color: RihlaColors.gold),
                      const SizedBox(width: 6),
                      Text(
                        '${currentWeather.city} · ${currentWeather.tempC}°C · ${currentWeather.condition} · ${currentWeather.windKmh} km/h',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: RihlaColors.seaBlueDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Material(
                color: RihlaColors.surface,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: RihlaColors.seaBlueDark),
                  onPressed: () => Navigator.of(context).pushNamed(Routes.notifications),
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: RihlaColors.coral,
                      shape: BoxShape.circle,
                      border: Border.all(color: RihlaColors.bg, width: 1.5),
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '$unreadCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final String hint;
  const _SearchBar({required this.onTap, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: RihlaColors.surface,
        borderRadius: BorderRadius.circular(RihlaSpace.radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RihlaSpace.radius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RihlaSpace.radius),
              boxShadow: RihlaShadows.soft,
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: RihlaColors.seaBlue),
                const SizedBox(width: 10),
                Text(hint, style: const TextStyle(color: RihlaColors.inkFaint, fontSize: 15)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: RihlaColors.sunsetGradient,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink)),
        ],
      ),
    );
  }
}

/// Wraps card imagery with the shared soft shadow + rounded clip.
class _CardShell extends StatelessWidget {
  final double width;
  final Widget child;
  final VoidCallback? onTap;
  const _CardShell({required this.width, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: RihlaColors.surface,
          borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
          boxShadow: RihlaShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Experience experience;
  const _FeaturedCard({required this.experience});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      width: 280,
      onTap: () => Navigator.of(context).pushNamed(Routes.detail, arguments: experience),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'exp-${experience.id}',
            child: LocalImage(path: experience.primaryImage, icon: experience.icon, label: experience.category),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          if (experience.badge != null)
            Positioned(top: 12, left: 12, child: RihlaBadge.sunset(experience.badge!, icon: Icons.local_fire_department_rounded)),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: GlassPanel(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(experience.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: RihlaColors.gold),
                      Text(' ${experience.rating} (${experience.reviewCount}) · ${experience.duration}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  PriceTag(original: experience.priceOriginal, discounted: experience.priceDiscounted, discountedFontSize: 15, light: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularCard extends StatelessWidget {
  final Experience experience;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  const _PopularCard({required this.experience, required this.isFavorite, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      width: 190,
      onTap: () => Navigator.of(context).pushNamed(Routes.detail, arguments: experience),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'exp-${experience.id}',
            child: LocalImage(path: experience.primaryImage, icon: experience.icon, label: experience.category),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onFavoriteToggle,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: AnimatedFavoriteIcon(isFavorite: isFavorite, size: 17, color: RihlaColors.coral),
              ),
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: GlassPanel(
              padding: const EdgeInsets.all(9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(experience.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: RihlaColors.gold),
                      Text(' ${experience.rating}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  PriceTag(original: experience.priceOriginal, discounted: experience.priceDiscounted, discountedFontSize: 13, light: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      width: 176,
      onTap: () => Navigator.of(context).pushNamed(Routes.restaurantDetail, arguments: restaurant),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'rest-${restaurant.id}',
            child: LocalImage(path: restaurant.primaryImage, icon: restaurant.icon, label: restaurant.cuisine),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          if (restaurant.badges.isNotEmpty)
            Positioned(top: 8, left: 8, child: RihlaBadge.soft(restaurant.badges.first)),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: GlassPanel(
              padding: const EdgeInsets.all(9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: RihlaColors.gold),
                      Text(' ${restaurant.rating} · ${restaurant.cuisine} · ${restaurant.priceRange}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
