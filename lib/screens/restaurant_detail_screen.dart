import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets/local_image.dart';
import '../widgets/rihla_badge.dart';

/// Restaurant detail — reached by tapping a restaurant card on Home/Explore.
/// Reads the [Restaurant] passed via route arguments. Restaurants aren't
/// bookable, so this is a rich informational screen (gallery + at-a-glance
/// facts) rather than the experience booking flow.
class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  int _heroIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    final photos = restaurant.images;
    final photoCount = photos.isEmpty ? 1 : photos.length;
    final heroIndex = _heroIndex.clamp(0, photoCount - 1);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                LocalImage(
                  path: photos.isEmpty ? '' : photos[heroIndex],
                  icon: restaurant.icon,
                  label: restaurant.cuisine,
                  height: 300,
                ),
                // Bottom scrim so the floating title stays legible.
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 12,
                  child: _CircleButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 12,
                  child: _CircleButton(
                    icon: Icons.share_outlined,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.linkCopied))),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.cuisine.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant.name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 26, letterSpacing: -0.6, height: 1.1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Thumbnail strip (only when there's more than one photo).
          if (photoCount > 1)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 92,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  scrollDirection: Axis.horizontal,
                  itemCount: photoCount,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, i) => GestureDetector(
                    onTap: () => setState(() => _heroIndex = i),
                    child: Container(
                      width: 76,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: heroIndex == i ? RihlaColors.seaBlue : Colors.transparent, width: 2.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: LocalImage(path: photos[i], icon: restaurant.icon, label: '${i + 1}', height: 72),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 20, color: RihlaColors.gold),
                    const SizedBox(width: 2),
                    Text('${restaurant.rating}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: RihlaColors.ink)),
                    Text('  ·  ${restaurant.reviewCount} ${l10n.reviews.toLowerCase()}', style: const TextStyle(color: RihlaColors.inkMuted)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: RihlaColors.goldTint,
                        borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
                      ),
                      child: Text(restaurant.priceRange, style: const TextStyle(fontWeight: FontWeight.w800, color: RihlaColors.seaBlueDark)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: restaurant.badges.map((b) => RihlaBadge.soft(b, icon: _badgeIcon(b))).toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: RihlaColors.surface,
                    borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                    boxShadow: RihlaShadows.soft,
                  ),
                  child: Column(
                    children: [
                      _FactRow(icon: Icons.restaurant_menu_rounded, color: RihlaColors.seaBlue, label: restaurant.cuisine),
                      const Divider(height: 1, indent: 60),
                      _FactRow(icon: Icons.payments_rounded, color: RihlaColors.gold, label: restaurant.priceRange),
                      const Divider(height: 1, indent: 60),
                      _FactRow(icon: Icons.star_rounded, color: RihlaColors.coral, label: '${restaurant.rating} · ${restaurant.reviewCount} ${l10n.reviews.toLowerCase()}'),
                    ],
                  ),
                ),
                if (restaurant.reviewsList.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(gradient: RihlaColors.sunsetGradient, borderRadius: BorderRadius.circular(4)),
                      ),
                      const SizedBox(width: 10),
                      Text(l10n.reviews, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink)),
                      const Spacer(),
                      const Icon(Icons.star_rounded, size: 18, color: RihlaColors.gold),
                      Text(' ${restaurant.rating}', style: const TextStyle(fontWeight: FontWeight.w800, color: RihlaColors.ink)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...restaurant.reviewsList.map((r) => _ReviewCard(review: r)),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  IconData _badgeIcon(String badge) {
    final b = badge.toUpperCase();
    if (b.contains('HALAL')) return Icons.verified_rounded;
    if (b.contains('VEG')) return Icons.eco_rounded;
    if (b.contains('OPEN')) return Icons.schedule_rounded;
    return Icons.local_offer_rounded;
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: Icon(icon, color: RihlaColors.seaBlueDark),
        onPressed: onTap,
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  const _FactRow({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: RihlaColors.ink))),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RihlaColors.surface,
        borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
        boxShadow: RihlaShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(review.countryFlag, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Flexible(child: Text(review.reviewerName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, color: RihlaColors.ink))),
                    if (review.isSubscriber) ...[
                      const SizedBox(width: 6),
                      RihlaBadge(
                        label: l10n.subscriberBadge,
                        icon: Icons.workspace_premium_rounded,
                        background: RihlaColors.goldTint,
                        foreground: RihlaColors.seaBlueDark,
                      ),
                    ],
                  ],
                ),
              ),
              Text(review.date, style: const TextStyle(fontSize: 11, color: RihlaColors.inkFaint)),
            ],
          ),
          const SizedBox(height: 6),
          Row(children: List.generate(5, (i) => Icon(i < review.rating ? Icons.star_rounded : Icons.star_border_rounded, size: 15, color: RihlaColors.gold))),
          const SizedBox(height: 8),
          Text(review.text, style: const TextStyle(color: RihlaColors.ink, height: 1.5)),
          if (review.vendorReply != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RihlaColors.seaTint,
                borderRadius: BorderRadius.circular(RihlaSpace.radius),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.storefront_rounded, size: 16, color: RihlaColors.seaBlue),
                  const SizedBox(width: 8),
                  Expanded(child: Text(review.vendorReply!, style: const TextStyle(fontSize: 13, color: RihlaColors.seaBlueDark, height: 1.4))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
