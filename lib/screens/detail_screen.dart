import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/gradient_image.dart';
import '../widgets/price_tag.dart';

/// S2 — Experience Detail (FR-027-037). Reads the [Experience] passed via
/// route arguments from a Home/Explore card tap.
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _heroIndex = 0;
  bool _isFavorite = false;
  bool _aboutExpanded = false;

  /// FR-037/BR-006: booking requires an active subscription. Without one,
  /// redirect to Subscription Plans instead of the booking flow.
  void _onBookPressed(BuildContext context, AppLocalizations l10n, Experience experience) {
    final sub = userSubscription;
    if (sub == null || !sub.active) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.subscriptionRequired)));
      Navigator.of(context).pushNamed(Routes.plans);
      return;
    }
    Navigator.of(context).pushNamed(Routes.booking1, arguments: experience);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final experience = ModalRoute.of(context)!.settings.arguments as Experience;
    final avgRating = experience.reviewsList.isEmpty
        ? experience.rating
        : experience.reviewsList.map((r) => r.rating).reduce((a, b) => a + b) / experience.reviewsList.length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                GradientImage(icon: experience.icon, label: l10n.photoIndicator(_heroIndex + 1, 4), height: 320),
                Positioned(
                  top: 40,
                  left: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 12,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent),
                          onPressed: () => setState(() => _isFavorite = !_isFavorite),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.share_outlined),
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.linkCopied))),
                        ),
                      ),
                    ],
                  ),
                ),
                if (experience.badge != null)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: RihlaColors.gold, borderRadius: BorderRadius.circular(8)),
                      child: Text(experience.badge!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 96,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () => setState(() => _heroIndex = i),
                  child: Container(
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _heroIndex == i ? RihlaColors.seaBlue : Colors.transparent, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: GradientImage(icon: experience.icon, label: '${i + 1}', height: 76),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(experience.category, style: const TextStyle(color: RihlaColors.seaBlue, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(experience.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: RihlaColors.gold),
                    Text(' $avgRating (${experience.reviewCount} ${l10n.reviews.toLowerCase()})', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoPill(icon: Icons.schedule, label: experience.duration),
                    _InfoPill(icon: Icons.terrain, label: experience.difficulty),
                    if (experience.hotelPickup) _InfoPill(icon: Icons.directions_car, label: l10n.hotelPickup),
                    _InfoPill(icon: Icons.language, label: experience.languages),
                    if (experience.freeCancellation) _InfoPill(icon: Icons.event_available, label: l10n.freeCancellation),
                  ],
                ),
                const Divider(height: 32),
                Text(l10n.about, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  experience.about,
                  maxLines: _aboutExpanded ? null : 2,
                  overflow: _aboutExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                TextButton(
                  onPressed: () => setState(() => _aboutExpanded = !_aboutExpanded),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                  child: Text(_aboutExpanded ? l10n.readLess : l10n.readMore),
                ),
                const Divider(height: 32),
                Text(l10n.included, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...experience.included.map((i) => _ChecklistRow(text: i, included: true)),
                ...experience.excluded.map((i) => _ChecklistRow(text: i, included: false)),
                const Divider(height: 32),
                Text(l10n.itinerary, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...experience.itinerary.asMap().entries.map((entry) => _ItineraryRow(
                      index: entry.key + 1,
                      stop: entry.value,
                      isLast: entry.key == experience.itinerary.length - 1,
                    )),
                const Divider(height: 32),
                Row(
                  children: [
                    Text(l10n.reviews, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    const Icon(Icons.star, size: 18, color: RihlaColors.gold),
                    Text(' $avgRating', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                ...experience.reviewsList.map((r) => _ReviewCard(review: r)),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))],
          ),
          child: Row(
            children: [
              PriceTag(original: experience.priceOriginal, discounted: experience.priceDiscounted, discountedFontSize: 20),
              const Spacer(),
              SizedBox(
                width: 140,
                child: FilledButton(
                  onPressed: () => _onBookPressed(context, l10n, experience),
                  child: Text(l10n.book),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: RihlaColors.bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: RihlaColors.seaBlueDark),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final String text;
  final bool included;
  const _ChecklistRow({required this.text, required this.included});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(included ? Icons.check_circle : Icons.cancel, size: 18, color: included ? Colors.green : Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: included ? null : Colors.grey))),
        ],
      ),
    );
  }
}

class _ItineraryRow extends StatelessWidget {
  final int index;
  final ItineraryStop stop;
  final bool isLast;
  const _ItineraryRow({required this.index, required this.stop, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(radius: 12, backgroundColor: RihlaColors.seaBlue, child: Text('$index', style: const TextStyle(color: Colors.white, fontSize: 11))),
              if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stop.time, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(stop.description),
                ],
              ),
            ),
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(review.countryFlag),
              const SizedBox(width: 6),
              Text(review.reviewerName, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (review.isSubscriber) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: RihlaColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                  child: Text(l10n.subscriberBadge, style: const TextStyle(fontSize: 10, color: RihlaColors.seaBlueDark)),
                ),
              ],
              const Spacer(),
              Text(review.date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          Row(children: List.generate(5, (i) => Icon(i < review.rating ? Icons.star : Icons.star_border, size: 14, color: RihlaColors.gold))),
          const SizedBox(height: 4),
          Text(review.text),
        ],
      ),
    );
  }
}
