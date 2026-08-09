import 'dart:ui';
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

/// Category → glyph for the Home chip rail.
const _categoryIcon = <String, IconData>{
  'Diving': Icons.scuba_diving_rounded,
  'Desert Safari': Icons.terrain_rounded,
  'Snorkeling': Icons.waves_rounded,
  'Boat Tours': Icons.sailing_rounded,
  'Seafood': Icons.set_meal_rounded,
  'Giftun Islands': Icons.beach_access_rounded,
  'Quad Biking': Icons.two_wheeler_rounded,
  'Spa & Wellness': Icons.spa_rounded,
  'Nightlife': Icons.nightlife_rounded,
  'Cultural': Icons.account_balance_rounded,
};

/// S1 — Home (FR-010-024). Hosted as the Home tab body in [MainShell].
///
/// Redesigned to an editorial "travel magazine" landing: a cinematic parallax
/// hero, a floating search bar, iconic category chips, a focus-scaling Featured
/// spotlight, refined rails, and a vertical "Recommended" feed. All behavior
/// (search/chips navigate to Explore, guest-gated Home-local favorites) is
/// unchanged.
class HomeScreen extends StatefulWidget {
  final VoidCallback onSearchTap;
  const HomeScreen({super.key, required this.onSearchTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> _favoriteIds = {};
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

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
    // Presentational feed over existing data — a distinct ordering from the
    // rating-sorted "Popular" rail so it doesn't read as a duplicate.
    final recommended = experiences.reversed.toList();

    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.only(bottom: 28),
      children: [
        FadeInUp(
          child: _HomeHero(
            scroll: _scroll,
            greeting: '${_greeting(l10n)}, ${currentUser.firstName}',
            tagline: l10n.heroTagline,
            hint: l10n.searchHint,
            tapToSearch: l10n.tapToSearch,
            unreadCount: unreadCount,
            onSearchTap: widget.onSearchTap,
          ),
        ),
        const SizedBox(height: 14),
        FadeInUp(
          delay: const Duration(milliseconds: 120),
          child: SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg),
              scrollDirection: Axis.horizontal,
              itemCount: homeCategories.length,
              separatorBuilder: (_, _) => const SizedBox(width: RihlaSpace.sm),
              itemBuilder: (context, i) => _CategoryChip(
                label: homeCategories[i],
                icon: _categoryIcon[homeCategories[i]] ?? Icons.tag_rounded,
                onTap: widget.onSearchTap,
              ),
            ),
          ),
        ),
        const SizedBox(height: RihlaSpace.xl),
        FadeInUp(delay: const Duration(milliseconds: 160), child: _SectionHeader(title: l10n.featured, onSeeAll: widget.onSearchTap, seeAllLabel: l10n.seeAll)),
        const SizedBox(height: RihlaSpace.md),
        FadeInUp(delay: const Duration(milliseconds: 160), child: _FeaturedSpotlight(items: featured)),
        const SizedBox(height: RihlaSpace.xl),
        FadeInUp(delay: const Duration(milliseconds: 200), child: _SectionHeader(title: l10n.popular, onSeeAll: widget.onSearchTap, seeAllLabel: l10n.seeAll)),
        const SizedBox(height: RihlaSpace.md),
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: SizedBox(
            height: 226,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg),
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
        const SizedBox(height: RihlaSpace.xl),
        FadeInUp(delay: const Duration(milliseconds: 240), child: _SectionHeader(title: l10n.recommendedForYou, onSeeAll: widget.onSearchTap, seeAllLabel: l10n.seeAll)),
        const SizedBox(height: RihlaSpace.md),
        for (var i = 0; i < recommended.length; i++)
          FadeInUp(
            delay: Duration(milliseconds: 260 + (i * 40).clamp(0, 200)),
            offset: 14,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(RihlaSpace.lg, 0, RihlaSpace.lg, RihlaSpace.md),
              child: _RecommendedCard(
                experience: recommended[i],
                isFavorite: _favoriteIds.contains(recommended[i].id),
                onFavoriteToggle: () => _toggleFavorite(recommended[i].id),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Cinematic hero
// ---------------------------------------------------------------------------

class _HomeHero extends StatelessWidget {
  final ScrollController scroll;
  final String greeting;
  final String tagline;
  final String hint;
  final String tapToSearch;
  final int unreadCount;
  final VoidCallback onSearchTap;

  const _HomeHero({
    required this.scroll,
    required this.greeting,
    required this.tagline,
    required this.hint,
    required this.tapToSearch,
    required this.unreadCount,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final reduce = media.disableAnimations;
    final heroH = (media.size.height * 0.32).clamp(260.0, 320.0);
    const overhang = 30.0;

    return SizedBox(
      height: heroH + overhang,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroH,
            child: ClipRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Parallax photo — drifts slower than the scrolling content.
                  AnimatedBuilder(
                    animation: scroll,
                    builder: (context, child) {
                      final off = (scroll.hasClients ? scroll.offset : 0.0).clamp(0.0, heroH);
                      final dy = reduce ? 0.0 : off * 0.4;
                      return Transform.translate(
                        offset: Offset(0, dy),
                        child: Transform.scale(scale: 1.18, child: child),
                      );
                    },
                    child: const LocalImage(
                      path: 'assets/giftun/giftun (1).jpg',
                      icon: Icons.sailing_rounded,
                      label: 'Hurghada',
                    ),
                  ),
                  // Legibility scrim + a warm sunset kiss at the top.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x33E8B23A), Colors.transparent, Color(0xCC0B2A38)],
                        stops: [0, 0.35, 1],
                      ),
                    ),
                  ),
                  // Greeting / weather glass panel — the bell lives in its top
                  // row so it reads as one grouped block instead of floating
                  // alone in the empty photo above.
                  Positioned(
                    left: RihlaSpace.lg,
                    right: RihlaSpace.lg,
                    bottom: 44,
                    child: GlassPanel(
                      borderRadius: RihlaSpace.radiusLg,
                      blur: 14,
                      padding: const EdgeInsets.all(RihlaSpace.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      greeting,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: RihlaColors.onBrand, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(tagline, style: const TextStyle(color: RihlaColors.onBrandMuted, fontSize: 14, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: RihlaSpace.md),
                              _FrostedCircleButton(
                                icon: Icons.notifications_none_rounded,
                                badgeCount: unreadCount,
                                onTap: () => Navigator.of(context).pushNamed(Routes.notifications),
                              ),
                            ],
                          ),
                          const SizedBox(height: RihlaSpace.md),
                          Row(
                            children: [
                              const Icon(Icons.wb_sunny_rounded, size: 16, color: RihlaColors.gold),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '${currentWeather.city} · ${currentWeather.tempC}°C · ${currentWeather.condition}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: RihlaColors.onBrand, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Floating search bar straddling the hero's bottom edge.
          Positioned(
            left: RihlaSpace.lg,
            right: RihlaSpace.lg,
            bottom: 0,
            child: _FloatingSearchBar(hint: hint, tapToSearch: tapToSearch, onTap: onSearchTap),
          ),
        ],
      ),
    );
  }
}

class _FrostedCircleButton extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;
  const _FrostedCircleButton({required this.icon, required this.badgeCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: RihlaColors.onBrand.withValues(alpha: 0.18),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(icon, color: RihlaColors.onBrand),
                ),
              ),
            ),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: RihlaColors.coral,
                shape: BoxShape.circle,
                border: Border.all(color: RihlaColors.onBrand, width: 1.5),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text('$badgeCount', textAlign: TextAlign.center, style: const TextStyle(color: RihlaColors.onBrand, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }
}

class _FloatingSearchBar extends StatelessWidget {
  final String hint;
  final String tapToSearch;
  final VoidCallback onTap;
  const _FloatingSearchBar({required this.hint, required this.tapToSearch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RihlaColors.surface,
      borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
            boxShadow: RihlaShadows.raised,
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: RihlaColors.seaBlue),
              const SizedBox(width: 10),
              Expanded(child: Text(hint, style: const TextStyle(color: RihlaColors.inkFaint, fontSize: 15))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: RihlaColors.seaTint, borderRadius: BorderRadius.circular(RihlaSpace.radiusPill)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tapToSearch, style: const TextStyle(color: RihlaColors.seaBlueDark, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 3),
                    const Icon(Icons.arrow_forward_rounded, size: 12, color: RihlaColors.seaBlueDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category chips
// ---------------------------------------------------------------------------

class _CategoryChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _CategoryChip({required this.label, required this.icon, required this.onTap});

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: RihlaColors.surface,
            borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
            border: Border.all(color: RihlaColors.hairline),
            boxShadow: RihlaShadows.soft,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 17, color: RihlaColors.seaBlue),
              const SizedBox(width: 7),
              Text(widget.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: RihlaColors.ink)),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final String seeAllLabel;
  const _SectionHeader({required this.title, this.onSeeAll, this.seeAllLabel = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(gradient: RihlaColors.sunsetGradient, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink)),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.sm), minimumSize: const Size(0, 36)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(seeAllLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const Icon(Icons.arrow_forward_rounded, size: 15),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Featured spotlight (peek + focus-scaling)
// ---------------------------------------------------------------------------

class _FeaturedSpotlight extends StatefulWidget {
  final List<Experience> items;
  const _FeaturedSpotlight({required this.items});

  @override
  State<_FeaturedSpotlight> createState() => _FeaturedSpotlightState();
}

class _FeaturedSpotlightState extends State<_FeaturedSpotlight> {
  late final PageController _pc = PageController(viewportFraction: 0.84);
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _pc.addListener(() => setState(() => _page = _pc.page ?? 0));
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _pc,
            itemCount: widget.items.length,
            itemBuilder: (context, i) {
              final delta = (_page - i).abs();
              final scale = reduce ? 1.0 : (1 - delta * 0.08).clamp(0.9, 1.0);
              final opacity = reduce ? 1.0 : (1 - delta * 0.4).clamp(0.55, 1.0);
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _FeaturedCard(experience: widget.items[i]),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: RihlaSpace.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (i) {
            final active = (_page.round()) == i;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active ? RihlaColors.seaBlue : RihlaColors.hairline,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Press feedback wrapper
// ---------------------------------------------------------------------------

class _Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _Pressable({required this.child, required this.onTap});

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
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
    return _Pressable(
      onTap: onTap ?? () {},
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: RihlaColors.surface,
          borderRadius: BorderRadius.circular(20),
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
      width: double.infinity,
      onTap: () => Navigator.of(context).pushNamed(Routes.detail, arguments: experience),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'home-featured-exp-${experience.id}',
            child: LocalImage(path: experience.primaryImage, icon: experience.icon, label: experience.category),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.center, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54]),
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
                  Text(experience.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: RihlaColors.gold),
                      Text(' ${experience.rating} (${experience.reviewCount}) · ${experience.duration}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  PriceTag(original: experience.priceOriginal, discounted: experience.priceDiscounted, discountedFontSize: 16, light: true),
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
      width: 196,
      onTap: () => Navigator.of(context).pushNamed(Routes.detail, arguments: experience),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'home-popular-exp-${experience.id}',
            child: LocalImage(path: experience.primaryImage, icon: experience.icon, label: experience.category),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.center, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54]),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onFavoriteToggle,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: AnimatedFavoriteIcon(isFavorite: isFavorite, size: 18, color: RihlaColors.coral),
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

/// Large editorial card for the vertical "Recommended" feed.
class _RecommendedCard extends StatelessWidget {
  final Experience experience;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  const _RecommendedCard({required this.experience, required this.isFavorite, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: () => Navigator.of(context).pushNamed(Routes.detail, arguments: experience),
      child: Container(
        decoration: BoxDecoration(
          color: RihlaColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: RihlaShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: LocalImage(path: experience.primaryImage, icon: experience.icon, label: experience.category),
                ),
                Positioned(
                  top: RihlaSpace.md,
                  left: RihlaSpace.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: RihlaColors.seaBlueDark.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
                    ),
                    child: Text(experience.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: RihlaColors.onBrand, letterSpacing: 0.2)),
                  ),
                ),
                Positioned(
                  top: RihlaSpace.sm,
                  right: RihlaSpace.sm,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: AnimatedFavoriteIcon(isFavorite: isFavorite, size: 19, color: RihlaColors.coral),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(RihlaSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(experience.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.3, color: RihlaColors.ink, height: 1.2)),
                  const SizedBox(height: RihlaSpace.sm),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: RihlaColors.gold),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text('${experience.rating} (${experience.reviewCount}) · ${experience.duration}',
                            maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: RihlaColors.inkMuted, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: RihlaSpace.md),
                  PriceTag(original: experience.priceOriginal, discounted: experience.priceDiscounted, discountedFontSize: 17),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

