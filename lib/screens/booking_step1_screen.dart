import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../booking_data.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/rihla_app_bar.dart';

const int _maxGuests = 12;

/// S3 — Booking Step 1: Date / Time / Guests (FR-038-043).
class BookingStep1Screen extends StatefulWidget {
  const BookingStep1Screen({super.key});

  @override
  State<BookingStep1Screen> createState() => _BookingStep1ScreenState();
}

class _BookingStep1ScreenState extends State<BookingStep1Screen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedSlot;
  int _adults = 1;
  int _children = 0;

  bool get _canContinue => _selectedDay != null && _selectedSlot != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final experience = ModalRoute.of(context)!.settings.arguments as Experience;
    final today = DateTime.now();
    final firstDay = DateTime(today.year, today.month, today.day);

    return Scaffold(
      appBar: RihlaAppBar(title: Text(experience.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RihlaSpace.lg),
          children: [
            const _BookingStepper(current: 0),
            const SizedBox(height: RihlaSpace.xl),
            Text(
              l10n.chooseDateTime,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: RihlaSpace.md),
            Container(
              decoration: BoxDecoration(
                color: RihlaColors.surface,
                borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                boxShadow: RihlaShadows.soft,
              ),
              padding: const EdgeInsets.all(RihlaSpace.sm),
              child: TableCalendar(
                firstDay: firstDay,
                lastDay: firstDay.add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                enabledDayPredicate: (day) => !day.isBefore(firstDay),
                onDaySelected: (selected, focused) => setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                }),
                calendarFormat: CalendarFormat.month,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: RihlaColors.ink,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left_rounded, color: RihlaColors.seaBlueDark),
                  rightChevronIcon: Icon(Icons.chevron_right_rounded, color: RihlaColors.seaBlueDark),
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(color: RihlaColors.gold, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: RihlaColors.seaBlue, shape: BoxShape.circle),
                  selectedTextStyle: TextStyle(color: RihlaColors.onBrand, fontWeight: FontWeight.w700),
                  defaultTextStyle: TextStyle(color: RihlaColors.ink),
                  weekendTextStyle: TextStyle(color: RihlaColors.inkMuted),
                  disabledTextStyle: TextStyle(color: RihlaColors.inkFaint),
                  outsideTextStyle: TextStyle(color: RihlaColors.inkFaint),
                ),
              ),
            ),
            const SizedBox(height: RihlaSpace.xl),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: RihlaSpace.md,
              crossAxisSpacing: RihlaSpace.md,
              childAspectRatio: 2.6,
              children: timeSlots.map((slot) {
                final soldOut = slot.spotsLeft == 0;
                final selected = _selectedSlot == slot.time;
                return InkWell(
                  onTap: soldOut ? null : () => setState(() => _selectedSlot = slot.time),
                  borderRadius: BorderRadius.circular(RihlaSpace.radius),
                  child: Container(
                    decoration: BoxDecoration(
                      color: soldOut
                          ? RihlaColors.bg
                          : (selected ? RihlaColors.seaTint : RihlaColors.surface),
                      borderRadius: BorderRadius.circular(RihlaSpace.radius),
                      border: Border.all(
                        color: selected ? RihlaColors.seaBlue : RihlaColors.hairline,
                        width: selected ? 1.6 : 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slot.time,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: soldOut
                                  ? RihlaColors.inkFaint
                                  : (selected ? RihlaColors.seaBlueDark : RihlaColors.ink),
                            ),
                          ),
                          Text(
                            soldOut ? l10n.soldOut : l10n.spotsLeft(slot.spotsLeft),
                            style: TextStyle(
                              fontSize: 11,
                              color: soldOut
                                  ? RihlaColors.inkFaint
                                  : (selected ? RihlaColors.seaBlue : RihlaColors.inkMuted),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: RihlaSpace.xl),
            Container(
              decoration: BoxDecoration(
                color: RihlaColors.surface,
                borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
                boxShadow: RihlaShadows.soft,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: RihlaSpace.lg,
                vertical: RihlaSpace.sm,
              ),
              child: Column(
                children: [
                  _GuestStepper(
                    label: l10n.adults,
                    value: _adults,
                    onDecrement: _adults > 1 ? () => setState(() => _adults--) : null,
                    onIncrement: (_adults + _children) < _maxGuests ? () => setState(() => _adults++) : null,
                  ),
                  const Divider(height: 1),
                  _GuestStepper(
                    label: l10n.children,
                    value: _children,
                    onDecrement: _children > 0 ? () => setState(() => _children--) : null,
                    onIncrement: (_adults + _children) < _maxGuests ? () => setState(() => _children++) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _StickyActionBar(
        child: FilledButton(
          onPressed: _canContinue
              ? () => Navigator.of(context).pushNamed(
                    Routes.booking2,
                    arguments: BookingData(
                      experience: experience,
                      date: _selectedDay,
                      timeSlot: _selectedSlot,
                      adults: _adults,
                      children: _children,
                    ),
                  )
              : null,
          child: Text(l10n.continueLabel),
        ),
      ),
    );
  }
}

class _GuestStepper extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  const _GuestStepper({required this.label, required this.value, this.onDecrement, this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RihlaSpace.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: RihlaColors.ink,
              ),
            ),
          ),
          _StepperButton(icon: Icons.remove_rounded, onTap: onDecrement),
          SizedBox(
            width: 44,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: RihlaColors.ink),
            ),
          ),
          _StepperButton(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepperButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled ? RihlaColors.seaTint : RihlaColors.bg,
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? RihlaColors.seaBlue.withValues(alpha: 0.35) : RihlaColors.hairline,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? RihlaColors.seaBlue : RihlaColors.inkFaint,
        ),
      ),
    );
  }
}

/// Segmented progress bar for the 3-step booking flow. Filled sea-blue for
/// completed and current steps; hairline for upcoming ones.
class _BookingStepper extends StatelessWidget {
  final int current;
  const _BookingStepper({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final done = i <= current;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? RihlaSpace.sm : 0.0),
            height: 6,
            decoration: BoxDecoration(
              color: done ? RihlaColors.seaBlue : RihlaColors.hairline,
              borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
            ),
          ),
        );
      }),
    );
  }
}

/// Sticky bottom action bar: a rounded surface lifted off the content with an
/// upward soft shadow, hosting the primary CTA.
class _StickyActionBar extends StatelessWidget {
  final Widget child;
  const _StickyActionBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RihlaColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(RihlaSpace.radiusLg)),
        boxShadow: RihlaShadows.stickyBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(RihlaSpace.lg, RihlaSpace.md, RihlaSpace.lg, RihlaSpace.md),
          child: child,
        ),
      ),
    );
  }
}
