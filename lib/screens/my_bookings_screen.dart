import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/booking_status_pill.dart';
import '../widgets/deposit_badge.dart';
import '../widgets/fade_in.dart';
import '../widgets/local_image.dart';
import '../widgets/price_tag.dart';
import '../widgets/rihla_app_bar.dart';

enum _Segment { upcoming, completed, cancelled, missed }

BookingStatus _statusOf(_Segment s) => switch (s) {
      _Segment.upcoming => BookingStatus.confirmed,
      _Segment.completed => BookingStatus.completed,
      _Segment.cancelled => BookingStatus.cancelled,
      _Segment.missed => BookingStatus.missedNoShow,
    };

/// First bundled photo of the experience a booking refers to (matched by
/// title), or '' when there's no match — [LocalImage] then draws its gradient
/// placeholder, so a card never shows a broken image.
String _thumbFor(Booking b) {
  for (final e in experiences) {
    if (e.title == b.experienceTitle) return e.primaryImage;
  }
  return '';
}

/// S6e — My Bookings History (FR-072). Hosted as the Bookings tab body
/// (no own Scaffold -- relies on MainShell's) and also reachable standalone
/// from Profile via Routes.myBookings (needs its own Scaffold there).
///
/// Redesigned to an organized "trips" surface: status segments, image-forward
/// tappable cards with a detail sheet, and clearer actions. All behavior
/// (guest gate, cancel→refund, review flow, hosting modes) is unchanged.
class MyBookingsScreen extends StatefulWidget {
  final bool standalone;

  /// Switches the shell to the Explore tab (tab mode only). Null in standalone
  /// mode, where the empty-state CTA pops back to the shell instead.
  final VoidCallback? onExploreTap;

  const MyBookingsScreen({super.key, this.standalone = false, this.onExploreTap});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  _Segment _segment = _Segment.upcoming;

  Future<void> _confirmCancel(Booking booking) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.cancelConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.cancelBooking)),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        booking.status = BookingStatus.cancelled;
        final creditType = booking.creditTypeConsumed;
        final sub = userSubscription;
        if (creditType != null && sub != null) {
          sub.creditsRemaining[creditType] = (sub.creditsRemaining[creditType] ?? 0) + 1;
        }
      });
    }
  }

  Future<void> _openWriteReview(Booking booking) async {
    await Navigator.of(context).pushNamed(Routes.writeReview, arguments: booking);
    // Refresh so a just-submitted review hides the CTA (reviewLeft is now true).
    if (mounted) setState(() {});
  }

  void _contactSupport(Booking booking) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.contactSupport)));
  }

  Future<void> _openDetail(Booking booking) async {
    await Navigator.of(context).pushNamed(Routes.ticketDetail, arguments: booking);
    // Refresh so a cancel/review action taken on the detail screen reflects here.
    if (mounted) setState(() {});
  }

  void _onExplore() {
    if (widget.onExploreTap != null) {
      widget.onExploreTap!();
    } else {
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Guests have no bookings — gate the whole screen behind a sign-in prompt.
    if (isGuest) {
      final guest = const SafeArea(child: _GuestGateHero());
      if (!widget.standalone) return guest;
      return Scaffold(appBar: RihlaAppBar(title: Text(l10n.myBookings)), body: guest);
    }

    final Widget content = SafeArea(
      child: bookings.isEmpty
          ? _BookingsEmptyState(onExplore: _onExplore)
          : _buildList(l10n),
    );

    if (!widget.standalone) return content;
    return Scaffold(
      appBar: RihlaAppBar(title: Text(l10n.myBookings)),
      body: content,
    );
  }

  Widget _buildList(AppLocalizations l10n) {
    final segmentItems = bookings.where((b) => b.status == _statusOf(_segment)).toList().reversed.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(RihlaSpace.lg, RihlaSpace.lg, RihlaSpace.lg, RihlaSpace.xxl),
      children: [
        if (!widget.standalone) ...[
          Text(l10n.myBookings, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: RihlaSpace.lg),
        ],
        _BookingSegments(
          selected: _segment,
          countFor: (s) => bookings.where((b) => b.status == _statusOf(s)).length,
          onSelect: (s) => setState(() => _segment = s),
        ),
        const SizedBox(height: RihlaSpace.lg),
        // Cross-fade between segments; keyed so the switch animates.
        AnimatedSwitcher(
          duration: MediaQuery.of(context).disableAnimations ? Duration.zero : const Duration(milliseconds: 220),
          child: segmentItems.isEmpty
              ? _SegmentEmpty(key: ValueKey('empty-${_segment.name}'), message: l10n.segmentEmpty)
              : Column(
                  key: ValueKey('list-${_segment.name}-${segmentItems.length}'),
                  children: [
                    for (var i = 0; i < segmentItems.length; i++)
                      FadeInUp(
                        delay: Duration(milliseconds: (i * 55).clamp(0, 275)),
                        offset: 12,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: RihlaSpace.md),
                          child: _BookingCard(
                            booking: segmentItems[i],
                            thumb: _thumbFor(segmentItems[i]),
                            onTap: () => _openDetail(segmentItems[i]),
                            onCancel: () => _confirmCancel(segmentItems[i]),
                            onReview: () => _openWriteReview(segmentItems[i]),
                            onContactSupport: () => _contactSupport(segmentItems[i]),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Segmented control
// ---------------------------------------------------------------------------

class _BookingSegments extends StatelessWidget {
  final _Segment selected;
  final int Function(_Segment) countFor;
  final ValueChanged<_Segment> onSelect;

  const _BookingSegments({required this.selected, required this.countFor, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = {
      _Segment.upcoming: l10n.bookingsUpcoming,
      _Segment.completed: l10n.statusCompleted,
      _Segment.cancelled: l10n.statusCancelled,
      _Segment.missed: l10n.statusMissedNoShow,
    };
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: RihlaColors.seaTint.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
      ),
      child: Row(
        children: _Segment.values.map((s) {
          return Expanded(
            child: _SegmentPill(
              label: labels[s]!,
              count: countFor(s),
              selected: selected == s,
              onTap: () => onSelect(s),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SegmentPill extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentPill({required this.label, required this.count, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? RihlaColors.seaBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
          boxShadow: selected ? RihlaShadows.soft : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? RihlaColors.onBrand : RihlaColors.inkMuted,
                ),
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 5),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? RihlaColors.onBrandMuted : RihlaColors.inkFaint,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Booking card
// ---------------------------------------------------------------------------

class _BookingCard extends StatefulWidget {
  final Booking booking;
  final String thumb;
  final VoidCallback onTap;
  final VoidCallback onCancel;
  final VoidCallback onReview;
  final VoidCallback onContactSupport;

  const _BookingCard({
    required this.booking,
    required this.thumb,
    required this.onTap,
    required this.onCancel,
    required this.onReview,
    required this.onContactSupport,
  });

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final b = widget.booking;
    final cancelled = b.status == BookingStatus.cancelled;

    final showCancel = b.status == BookingStatus.confirmed;
    final showReview = b.status == BookingStatus.completed && !b.reviewLeft && b.hasEnded;
    final showContactSupport = b.status == BookingStatus.missedNoShow;
    final hasFooter = showCancel || showReview || showContactSupport;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
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
              Padding(
                padding: const EdgeInsets.all(RihlaSpace.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: cancelled ? 0.55 : 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(RihlaSpace.radius),
                        child: SizedBox(
                          width: 92,
                          height: 92,
                          child: LocalImage(path: widget.thumb, icon: b.icon, label: b.experienceTitle),
                        ),
                      ),
                    ),
                    const SizedBox(width: RihlaSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  b.experienceTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    letterSpacing: -0.2,
                                    height: 1.2,
                                    color: cancelled ? RihlaColors.inkMuted : RihlaColors.ink,
                                  ),
                                ),
                              ),
                              const SizedBox(width: RihlaSpace.sm),
                              BookingStatusPill(status: b.status),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.event_rounded, size: 14, color: RihlaColors.inkFaint),
                              const SizedBox(width: 5),
                              Text('${formatDate(b.date)} · ${b.time}',
                                  style: const TextStyle(color: RihlaColors.inkMuted, fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: RihlaSpace.sm),
                          if (b.discountPct > 0)
                            PriceTag(original: b.originalPriceEur, discounted: b.finalPriceEur, discountedFontSize: 17)
                          else
                            Text(formatEur(b.finalPriceEur),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                  letterSpacing: -0.3,
                                  color: cancelled ? RihlaColors.inkMuted : RihlaColors.ink,
                                )),
                          const SizedBox(height: RihlaSpace.sm),
                          DepositBadge(status: b.deposit.status),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (hasFooter)
                Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: RihlaColors.hairline)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.md, vertical: RihlaSpace.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (showCancel)
                        OutlinedButton(
                          onPressed: widget.onCancel,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 42),
                            foregroundColor: RihlaColors.statusCancelled,
                            side: const BorderSide(color: RihlaColors.hairline),
                            padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RihlaSpace.radiusPill)),
                          ),
                          child: Text(l10n.cancelBooking),
                        ),
                      if (showReview)
                        FilledButton.icon(
                          onPressed: widget.onReview,
                          icon: const Icon(Icons.star_rounded, size: 18),
                          label: Text(l10n.rateExperience),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 42),
                            backgroundColor: RihlaColors.seaBlue,
                            padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RihlaSpace.radiusPill)),
                          ),
                        ),
                      if (showContactSupport)
                        FilledButton.icon(
                          onPressed: widget.onContactSupport,
                          icon: const Icon(Icons.support_agent_rounded, size: 18),
                          label: Text(l10n.contactSupport),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 42),
                            backgroundColor: RihlaColors.seaBlue,
                            padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.lg),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RihlaSpace.radiusPill)),
                          ),
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


// ---------------------------------------------------------------------------
// Empty / guest states
// ---------------------------------------------------------------------------

/// Small inline message when the selected segment has no bookings but others do.
class _SegmentEmpty extends StatelessWidget {
  final String message;
  const _SegmentEmpty({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RihlaSpace.xxl),
      child: Column(
        children: [
          const Icon(Icons.inbox_rounded, size: 40, color: RihlaColors.inkFaint),
          const SizedBox(height: RihlaSpace.sm),
          Text(message, style: const TextStyle(color: RihlaColors.inkMuted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Signed-in traveler with zero bookings.
class _BookingsEmptyState extends StatelessWidget {
  final VoidCallback onExplore;
  const _BookingsEmptyState({required this.onExplore});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FadeInUp(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(RihlaSpace.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(color: RihlaColors.seaTint, shape: BoxShape.circle),
                child: const Icon(Icons.confirmation_number_rounded, size: 42, color: RihlaColors.seaBlue),
              ),
              const SizedBox(height: RihlaSpace.lg),
              Text(l10n.noBookingsTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink)),
              const SizedBox(height: RihlaSpace.sm),
              Text(l10n.noBookingsBody, textAlign: TextAlign.center, style: const TextStyle(color: RihlaColors.inkMuted, height: 1.5)),
              const SizedBox(height: RihlaSpace.xl),
              FilledButton.icon(
                onPressed: onExplore,
                icon: const Icon(Icons.explore_rounded, size: 20),
                label: Text(l10n.exploreExperiences),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: RihlaSpace.xl),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RihlaSpace.radiusPill)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Guest gate — sign in to see bookings.
class _GuestGateHero extends StatelessWidget {
  const _GuestGateHero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FadeInUp(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(RihlaSpace.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RihlaColors.seaGradient,
                  boxShadow: [
                    BoxShadow(color: RihlaColors.seaBlue.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8)),
                  ],
                ),
                child: const Icon(Icons.confirmation_number_rounded, color: RihlaColors.onBrand, size: 44),
              ),
              const SizedBox(height: RihlaSpace.lg),
              Text(l10n.guestModeTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: RihlaColors.ink)),
              const SizedBox(height: RihlaSpace.sm),
              Text(l10n.guestModeBody, textAlign: TextAlign.center, style: const TextStyle(color: RihlaColors.inkMuted, height: 1.5)),
              const SizedBox(height: RihlaSpace.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushNamed(Routes.auth),
                  child: Text(l10n.signIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
