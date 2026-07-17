import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/local_image.dart';
import '../widgets/price_tag.dart';
import '../widgets/rihla_badge.dart';

enum _SortOption { relevance, topRated, priceLowHigh, priceHighLow, newest }

/// Maps a short Explore filter chip label (FR-059) to the matching
/// Experience.category value (FR-016). 'Restaurants' has no category match —
/// it toggles restaurant results in instead, handled separately below.
const _chipCategory = <String, String>{
  'Diving': 'Diving',
  'Desert': 'Desert Safari',
  'Snorkel': 'Snorkeling',
  'Boat Tours': 'Boat Tours',
  'Wellness': 'Spa & Wellness',
  'Cultural': 'Cultural',
};

/// S5 — Explore / Search (FR-057-064). Hosted as the Explore tab body.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  final Set<String> _selectedChips = {'All'};
  _SortOption _sort = _SortOption.relevance;
  RangeValues _priceRange = const RangeValues(0, 500);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleChip(String chip) {
    setState(() {
      if (chip == 'All') {
        _selectedChips
          ..clear()
          ..add('All');
        return;
      }
      _selectedChips.remove('All');
      if (_selectedChips.contains(chip)) {
        _selectedChips.remove(chip);
      } else {
        _selectedChips.add(chip);
      }
      if (_selectedChips.isEmpty) _selectedChips.add('All');
    });
  }

  String _sortLabel(AppLocalizations l10n, _SortOption o) => switch (o) {
        _SortOption.relevance => l10n.sortRelevance,
        _SortOption.topRated => l10n.sortTopRated,
        _SortOption.priceLowHigh => l10n.sortPriceLow,
        _SortOption.priceHighLow => l10n.sortPriceHigh,
        _SortOption.newest => l10n.sortNewest,
      };

  List<Experience> _filteredExperiences() {
    final query = _searchController.text.trim().toLowerCase();
    final showAll = _selectedChips.contains('All');
    final activeCategories = _selectedChips.map((c) => _chipCategory[c]).whereType<String>().toSet();

    var results = experiences.where((e) {
      if (query.length >= 2 && !e.title.toLowerCase().contains(query)) return false;
      if (e.priceDiscounted < _priceRange.start || e.priceDiscounted > _priceRange.end) return false;
      if (!showAll && activeCategories.isNotEmpty && !activeCategories.contains(e.category)) return false;
      return true;
    }).toList();

    switch (_sort) {
      case _SortOption.relevance:
      case _SortOption.topRated:
        results.sort((a, b) => b.rating.compareTo(a.rating));
      case _SortOption.priceLowHigh:
        results.sort((a, b) => a.priceDiscounted.compareTo(b.priceDiscounted));
      case _SortOption.priceHighLow:
        results.sort((a, b) => b.priceDiscounted.compareTo(a.priceDiscounted));
      case _SortOption.newest:
        results = results.reversed.toList();
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final results = _filteredExperiences();
    final showRestaurants = _selectedChips.contains('Restaurants');
    final totalCount = results.length + (showRestaurants ? restaurants.length : 0);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchHint,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: exploreFilterChips.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final chip = exploreFilterChips[i];
                return FilterChip(
                  label: Text(chip),
                  selected: _selectedChips.contains(chip),
                  onSelected: (_) => _toggleChip(chip),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<_SortOption>(
                      isExpanded: true,
                      value: _sort,
                      icon: const Icon(Icons.sort),
                      hint: Text(l10n.sortBy),
                      items: _SortOption.values
                          .map((o) => DropdownMenuItem(value: o, child: Text(_sortLabel(l10n, o))))
                          .toList(),
                      onChanged: (o) => setState(() => _sort = o ?? _sort),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RangeSlider(
              min: 0,
              max: 500,
              divisions: 50,
              labels: RangeLabels(formatEur(_priceRange.start.round()), formatEur(_priceRange.end.round())),
              values: _priceRange,
              onChanged: (v) => setState(() => _priceRange = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.resultsCount(totalCount), style: const TextStyle(color: RihlaColors.inkMuted, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: totalCount == 0
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: const BoxDecoration(color: RihlaColors.seaTint, shape: BoxShape.circle),
                          child: const Icon(Icons.travel_explore_rounded, size: 42, color: RihlaColors.seaBlue),
                        ),
                        const SizedBox(height: 16),
                        Text(l10n.noResults, style: const TextStyle(color: RihlaColors.inkMuted, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      ...results.map((e) => _ResultCard(experience: e)),
                      if (showRestaurants) ...restaurants.map((r) => _RestaurantResultCard(restaurant: r)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final Experience experience;
  const _ResultCard({required this.experience});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(Routes.detail, arguments: experience),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(width: 100, height: 100, child: LocalImage(path: experience.primaryImage, icon: experience.icon, label: experience.category)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(experience.title, style: const TextStyle(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 15, color: RihlaColors.gold),
                        Text(' ${experience.rating} (${experience.reviewCount}) · ${experience.duration}', style: const TextStyle(fontSize: 12, color: RihlaColors.inkMuted)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    PriceTag(original: experience.priceOriginal, discounted: experience.priceDiscounted, discountedFontSize: 14),
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

class _RestaurantResultCard extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantResultCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(Routes.restaurantDetail, arguments: restaurant),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(width: 100, height: 100, child: LocalImage(path: restaurant.primaryImage, icon: restaurant.icon, label: restaurant.cuisine)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: RihlaColors.gold),
                      Text(' ${restaurant.rating} (${restaurant.reviewCount}) · ${restaurant.priceRange}', style: const TextStyle(fontSize: 12, color: RihlaColors.inkMuted)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: restaurant.badges.map((b) => RihlaBadge.soft(b)).toList(),
                  ),
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
