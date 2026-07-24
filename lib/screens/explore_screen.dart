import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/animated_favorite_icon.dart';
import '../widgets/fade_in.dart';
import '../widgets/local_image.dart';
import '../widgets/price_tag.dart';
import '../widgets/sign_in_prompt.dart';

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

/// Small leading glyph per Explore filter chip — keeps the coastal-premium
/// Material-icon language rather than mixing in emoji.
const _chipIcon = <String, IconData>{
  'All': Icons.grid_view_rounded,
  'Diving': Icons.scuba_diving_rounded,
  'Desert': Icons.terrain_rounded,
  'Snorkel': Icons.waves_rounded,
  'Restaurants': Icons.restaurant_rounded,
  'Boat Tours': Icons.sailing_rounded,
  'Wellness': Icons.spa_rounded,
  'Cultural': Icons.account_balance_rounded,
};

/// Selected-chip / primary-CTA wash — richer than a flat fill, per the
/// redesign spec. Composed from existing tokens (sea-blue → coral).
const _accentGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [RihlaColors.seaBlue, RihlaColors.coral],
);

const _priceMin = 0.0;
const _priceMax = 500.0;

/// S5 — Explore / Search (FR-057-064). Hosted as the Explore tab body.
///
/// Redesigned to a collapsing, editorial travel-listing layout: a sticky
/// pill search bar, icon chips, a compact sort/filters row backed by a modal
/// filter sheet, and image-forward result cards with staggered entry. All
/// filtering/sorting behavior is unchanged from the original implementation.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  final Set<String> _selectedChips = {'All'};
  final Set<String> _favoriteIds = {};
  _SortOption _sort = _SortOption.relevance;
  RangeValues _priceRange = const RangeValues(_priceMin, _priceMax);

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

  bool get _priceChanged => _priceRange.start != _priceMin || _priceRange.end != _priceMax;

  /// Filters considered "active" for the search-bar dot and Filters badge:
  /// a moved price range plus any category chip beyond the default "All".
  int get _activeFilterCount => (_priceChanged ? 1 : 0) + _selectedChips.where((c) => c != 'All').length;

  String _sortLabel(AppLocalizations l10n, _SortOption o) => switch (o) {
        _SortOption.relevance => l10n.sortRelevance,
        _SortOption.topRated => l10n.sortTopRated,
        _SortOption.priceLowHigh => l10n.sortPriceLow,
        _SortOption.priceHighLow => l10n.sortPriceHigh,
        _SortOption.newest => l10n.sortNewest,
      };

  List<Experience> _filteredExperiences({_SortOption? sort, RangeValues? price}) {
    final activeSort = sort ?? _sort;
    final activePrice = price ?? _priceRange;
    final query = _searchController.text.trim().toLowerCase();
    final showAll = _selectedChips.contains('All');
    final activeCategories = _selectedChips.map((c) => _chipCategory[c]).whereType<String>().toSet();

    var results = experiences.where((e) {
      if (query.length >= 2 && !e.title.toLowerCase().contains(query)) return false;
      if (e.priceDiscounted < activePrice.start || e.priceDiscounted > activePrice.end) return false;
      if (!showAll && activeCategories.isNotEmpty && !activeCategories.contains(e.category)) return false;
      return true;
    }).toList();

    switch (activeSort) {
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

  /// Total shown count for a given (sort/price) combination — experiences plus
  /// restaurants when the Restaurants chip is active. Used live inside the
  /// filter sheet's "Show N results" button.
  int _countFor(_SortOption sort, RangeValues price) =>
      _filteredExperiences(sort: sort, price: price).length +
      (_selectedChips.contains('Restaurants') ? restaurants.length : 0);

  void _clearAll() {
    setState(() {
      _selectedChips
        ..clear()
        ..add('All');
      _sort = _SortOption.relevance;
      _priceRange = const RangeValues(_priceMin, _priceMax);
      _searchController.clear();
    });
  }

  Future<void> _openFilterSheet() async {
    final l10n = AppLocalizations.of(context)!;
    var tempSort = _sort;
    var tempPrice = _priceRange;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final liveCount = _countFor(tempSort, tempPrice);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(RihlaSpace.xl, 4, RihlaSpace.xl, RihlaSpace.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.filters,
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink)),
                    const SizedBox(height: RihlaSpace.lg),
                    // --- Sort ---
                    Text(l10n.sortBy,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: RihlaColors.inkMuted)),
                    const SizedBox(height: RihlaSpace.sm),
                    Wrap(
                      spacing: RihlaSpace.sm,
                      runSpacing: RihlaSpace.sm,
                      children: _SortOption.values.map((o) {
                        final selected = tempSort == o;
                        return GestureDetector(
                          onTap: () => setSheetState(() => tempSort = o),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected ? RihlaColors.seaBlue : RihlaColors.surface,
                              borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
                              border: Border.all(color: selected ? RihlaColors.seaBlue : RihlaColors.hairline),
                            ),
                            child: Text(
                              _sortLabel(l10n, o),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected ? RihlaColors.onBrand : RihlaColors.ink,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: RihlaSpace.xl),
                    // --- Price ---
                    Row(
                      children: [
                        Text(l10n.priceRangeLabel,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: RihlaColors.inkMuted)),
                        const Spacer(),
                        Text('${formatEur(tempPrice.start.round())} – ${formatEur(tempPrice.end.round())}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: RihlaColors.seaBlueDark)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6,
                        activeTrackColor: RihlaColors.seaBlue,
                        inactiveTrackColor: RihlaColors.seaTint,
                        thumbColor: RihlaColors.surface,
                        overlayColor: RihlaColors.seaBlue.withValues(alpha: 0.12),
                        rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 11),
                        rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                        valueIndicatorColor: RihlaColors.seaBlueDark,
                      ),
                      child: RangeSlider(
                        min: _priceMin,
                        max: _priceMax,
                        divisions: 50,
                        labels: RangeLabels(formatEur(tempPrice.start.round()), formatEur(tempPrice.end.round())),
                        values: tempPrice,
                        onChanged: (v) => setSheetState(() => tempPrice = v),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setSheetState(() => tempPrice = const RangeValues(_priceMin, _priceMax)),
                        child: Text(l10n.reset),
                      ),
                    ),
                    const SizedBox(height: RihlaSpace.md),
                    // --- Footer actions ---
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(sheetContext).pop();
                              _clearAll();
                            },
                            child: Text(l10n.clearAll),
                          ),
                        ),
                        const SizedBox(width: RihlaSpace.md),
                        Expanded(
                          flex: 2,
                          child: _GradientButton(
                            label: l10n.showResultsCount(liveCount),
                            onTap: () {
                              setState(() {
                                _sort = tempSort;
                                _priceRange = tempPrice;
                              });
                              Navigator.of(sheetContext).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final results = _filteredExperiences();
    final showRestaurants = _selectedChips.contains('Restaurants');
    final totalCount = results.length + (showRestaurants ? restaurants.length : 0);

    // Restaging key: the animation re-runs only when the visible set changes,
    // not on every keystroke that leaves results unchanged.
    final signature = [
      ...results.map((e) => e.id),
      if (showRestaurants) ...restaurants.map((r) => 'r-${r.id}'),
    ].join(',');

    return SafeArea(
      top: false,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: RihlaColors.bg,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            toolbarHeight: 72,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(RihlaSpace.lg, RihlaSpace.md, RihlaSpace.lg, RihlaSpace.md),
              child: _SearchBar(
                controller: _searchController,
                hint: l10n.searchHint,
                onChanged: (_) => setState(() {}),
                filterActive: _activeFilterCount > 0,
                onFilterTap: _openFilterSheet,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg),
                scrollDirection: Axis.horizontal,
                itemCount: exploreFilterChips.length,
                separatorBuilder: (_, _) => const SizedBox(width: RihlaSpace.sm),
                itemBuilder: (context, i) {
                  final chip = exploreFilterChips[i];
                  return _CategoryChip(
                    label: chip,
                    icon: _chipIcon[chip] ?? Icons.tag_rounded,
                    selected: _selectedChips.contains(chip),
                    onTap: () => _toggleChip(chip),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(RihlaSpace.lg, RihlaSpace.md, RihlaSpace.lg, RihlaSpace.sm),
              child: _SortFilterBar(
                sortLabel: _sortLabel(l10n, _sort),
                filtersLabel: l10n.filters,
                activeCount: _activeFilterCount,
                onTap: _openFilterSheet,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(RihlaSpace.lg, 0, RihlaSpace.lg, RihlaSpace.md),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.resultsCount(totalCount),
                  style: const TextStyle(color: RihlaColors.inkMuted, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          if (totalCount == 0)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(
                message: l10n.noResults,
                helper: l10n.noResultsHelp,
                showClear: _activeFilterCount > 0 || _searchController.text.isNotEmpty,
                clearLabel: l10n.clearFilters,
                onClear: _clearAll,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(RihlaSpace.lg, 0, RihlaSpace.lg, RihlaSpace.xxl),
              sliver: SliverList.list(
                children: [
                  for (var i = 0; i < results.length; i++)
                    FadeInUp(
                      key: ValueKey('$signature#e${results[i].id}'),
                      delay: Duration(milliseconds: (i * 40).clamp(0, 240)),
                      offset: 12,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: _ExperienceCard(
                          experience: results[i],
                          isFavorite: _favoriteIds.contains(results[i].id),
                          onFavoriteToggle: () => _toggleFavorite(results[i].id),
                        ),
                      ),
                    ),
                  if (showRestaurants)
                    for (var i = 0; i < restaurants.length; i++)
                      FadeInUp(
                        key: ValueKey('$signature#r${restaurants[i].id}'),
                        delay: Duration(milliseconds: ((results.length + i) * 40).clamp(0, 240)),
                        offset: 12,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: _RestaurantCard(restaurant: restaurants[i]),
                        ),
                      ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search bar
// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final bool filterActive;
  final VoidCallback onFilterTap;

  const _SearchBar({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.filterActive,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RihlaColors.surface,
        borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
        boxShadow: RihlaShadows.soft,
      ),
      padding: const EdgeInsets.only(left: RihlaSpace.lg, right: RihlaSpace.xs),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: RihlaColors.seaBlue),
          const SizedBox(width: RihlaSpace.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 15, color: RihlaColors.ink),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                hintText: hint,
                hintStyle: const TextStyle(color: RihlaColors.inkFaint, fontSize: 15),
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: onFilterTap,
                icon: const Icon(Icons.tune_rounded, color: RihlaColors.seaBlueDark),
                tooltip: MaterialLocalizations.of(context).modalBarrierDismissLabel,
              ),
              if (filterActive)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: RihlaColors.coral,
                      shape: BoxShape.circle,
                      border: Border.all(color: RihlaColors.surface, width: 1.5),
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

// ---------------------------------------------------------------------------
// Category chip — icon + label pill with a select pop
// ---------------------------------------------------------------------------

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            gradient: selected ? _accentGradient : null,
            color: selected ? null : RihlaColors.surface,
            borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
            border: Border.all(color: selected ? Colors.transparent : RihlaColors.hairline),
            boxShadow: selected ? RihlaShadows.soft : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: selected ? RihlaColors.onBrand : RihlaColors.inkMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? RihlaColors.onBrand : RihlaColors.ink,
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
// Sort + Filters compact row
// ---------------------------------------------------------------------------

class _SortFilterBar extends StatelessWidget {
  final String sortLabel;
  final String filtersLabel;
  final int activeCount;
  final VoidCallback onTap;

  const _SortFilterBar({
    required this.sortLabel,
    required this.filtersLabel,
    required this.activeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PillButton(
            icon: Icons.swap_vert_rounded,
            label: sortLabel,
            trailing: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: RihlaColors.inkMuted),
            onTap: onTap,
          ),
        ),
        const SizedBox(width: RihlaSpace.md),
        Expanded(
          child: _PillButton(
            icon: Icons.tune_rounded,
            label: filtersLabel,
            badgeCount: activeCount,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final int badgeCount;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RihlaColors.surface,
      borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
            border: Border.all(color: RihlaColors.hairline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: RihlaColors.seaBlueDark),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: RihlaColors.ink),
                ),
              ),
              if (badgeCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(2),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  decoration: const BoxDecoration(color: RihlaColors.coral, shape: BoxShape.circle),
                  child: Text(
                    '$badgeCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: RihlaColors.onBrand, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gradient primary button (filter sheet CTA)
// ---------------------------------------------------------------------------

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(RihlaSpace.radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RihlaSpace.radius),
        child: Ink(
          height: 54,
          decoration: BoxDecoration(
            gradient: _accentGradient,
            borderRadius: BorderRadius.circular(RihlaSpace.radius),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(color: RihlaColors.onBrand, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.1),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Result cards — shared editorial shell (top image + content block)
// ---------------------------------------------------------------------------

/// Whole-card press feedback: a gentle scale-down while held.
class _PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PressableCard({required this.child, required this.onTap});

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard> {
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

/// The shared card shell: full-width ~16:9 hero image with corner overlays,
/// then a content block below. Experience and restaurant cards differ only in
/// their overlays and the meta/trailing slots.
class _ResultCardShell extends StatelessWidget {
  final String heroTag;
  final String imagePath;
  final IconData icon;
  final String imageLabel;
  final String categoryLabel;
  final Widget? topRight;
  final Widget content;
  final VoidCallback onTap;

  const _ResultCardShell({
    required this.heroTag,
    required this.imagePath,
    required this.icon,
    required this.imageLabel,
    required this.categoryLabel,
    required this.content,
    required this.onTap,
    this.topRight,
  });

  @override
  Widget build(BuildContext context) {
    return _PressableCard(
      onTap: onTap,
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
                  child: Hero(
                    tag: heroTag,
                    child: LocalImage(path: imagePath, icon: icon, label: imageLabel),
                  ),
                ),
                Positioned(
                  top: RihlaSpace.md,
                  left: RihlaSpace.md,
                  child: _CategoryTag(label: categoryLabel),
                ),
                if (topRight != null)
                  Positioned(top: RihlaSpace.sm, right: RihlaSpace.sm, child: topRight!),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(RihlaSpace.lg),
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}

/// Frosted category label floated over the card image.
class _CategoryTag extends StatelessWidget {
  final String label;
  const _CategoryTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: RihlaColors.seaBlueDark.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: RihlaColors.onBrand, letterSpacing: 0.2),
      ),
    );
  }
}

/// Gold star + text meta row (`★ 4.9 (176) · 8h`).
class _MetaRow extends StatelessWidget {
  final String text;
  const _MetaRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 16, color: RihlaColors.gold),
        const SizedBox(width: 2),
        Expanded(
          child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: RihlaColors.inkMuted, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final Experience experience;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _ExperienceCard({required this.experience, required this.isFavorite, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return _ResultCardShell(
      heroTag: 'exp-${experience.id}',
      imagePath: experience.primaryImage,
      icon: experience.icon,
      imageLabel: experience.category,
      categoryLabel: experience.category,
      onTap: () => Navigator.of(context).pushNamed(Routes.detail, arguments: experience),
      topRight: GestureDetector(
        onTap: onFavoriteToggle,
        child: CircleAvatar(
          radius: 17,
          backgroundColor: Colors.white,
          child: AnimatedFavoriteIcon(isFavorite: isFavorite, size: 19, color: RihlaColors.coral),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            experience.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.3, color: RihlaColors.ink, height: 1.2),
          ),
          const SizedBox(height: RihlaSpace.sm),
          _MetaRow('${experience.rating} (${experience.reviewCount}) · ${experience.duration}'),
          const SizedBox(height: RihlaSpace.md),
          PriceTag(original: experience.priceOriginal, discounted: experience.priceDiscounted, discountedFontSize: 17),
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
    return _ResultCardShell(
      heroTag: 'rest-${restaurant.id}',
      imagePath: restaurant.primaryImage,
      icon: restaurant.icon,
      imageLabel: restaurant.cuisine,
      categoryLabel: restaurant.cuisine,
      onTap: () => Navigator.of(context).pushNamed(Routes.restaurantDetail, arguments: restaurant),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.3, color: RihlaColors.ink, height: 1.2),
          ),
          const SizedBox(height: RihlaSpace.sm),
          _MetaRow('${restaurant.rating} (${restaurant.reviewCount}) · ${restaurant.priceRange}'),
          if (restaurant.badges.isNotEmpty) ...[
            const SizedBox(height: RihlaSpace.md),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: restaurant.badges.map((b) => _OutlineBadge(b)).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Outline-style tag for restaurant attributes — distinct from the filled
/// category chips so the two never read as the same control.
class _OutlineBadge extends StatelessWidget {
  final String label;
  const _OutlineBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: RihlaColors.seaTint.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
        border: Border.all(color: RihlaColors.hairline),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: RihlaColors.seaBlueDark, letterSpacing: 0.2),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  final String message;
  final String helper;
  final bool showClear;
  final String clearLabel;
  final VoidCallback onClear;

  const _EmptyState({
    required this.message,
    required this.helper,
    required this.showClear,
    required this.clearLabel,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(RihlaSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 108,
              height: 108,
              decoration: const BoxDecoration(color: RihlaColors.seaTint, shape: BoxShape.circle),
              child: const Icon(Icons.travel_explore_rounded, size: 52, color: RihlaColors.seaBlue),
            ),
            const SizedBox(height: RihlaSpace.xl),
            Text(message, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: RihlaColors.ink)),
            const SizedBox(height: RihlaSpace.sm),
            Text(helper, textAlign: TextAlign.center, style: const TextStyle(color: RihlaColors.inkMuted, height: 1.4)),
            if (showClear) ...[
              const SizedBox(height: RihlaSpace.lg),
              OutlinedButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(clearLabel),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 46), padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.xl)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
