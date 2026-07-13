import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../booking_data.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../routes.dart';
import '../theme.dart';

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
      appBar: AppBar(title: Text(experience.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.chooseDateTime, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
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
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                calendarStyle: CalendarStyle(
                  todayDecoration: const BoxDecoration(color: RihlaColors.gold, shape: BoxShape.circle),
                  selectedDecoration: const BoxDecoration(color: RihlaColors.seaBlue, shape: BoxShape.circle),
                  disabledTextStyle: TextStyle(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.6,
              children: timeSlots.map((slot) {
                final soldOut = slot.spotsLeft == 0;
                final selected = _selectedSlot == slot.time;
                return InkWell(
                  onTap: soldOut ? null : () => setState(() => _selectedSlot = slot.time),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: soldOut ? Colors.grey.shade200 : (selected ? RihlaColors.seaBlue : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? RihlaColors.seaBlue : Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slot.time,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: soldOut ? Colors.grey : (selected ? Colors.white : Colors.black87),
                            ),
                          ),
                          Text(
                            soldOut ? l10n.soldOut : l10n.spotsLeft(slot.spotsLeft),
                            style: TextStyle(
                              fontSize: 11,
                              color: soldOut ? Colors.grey : (selected ? Colors.white70 : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 40),
            _GuestStepper(
              label: l10n.adults,
              value: _adults,
              onDecrement: _adults > 1 ? () => setState(() => _adults--) : null,
              onIncrement: (_adults + _children) < _maxGuests ? () => setState(() => _adults++) : null,
            ),
            const SizedBox(height: 12),
            _GuestStepper(
              label: l10n.children,
              value: _children,
              onDecrement: _children > 0 ? () => setState(() => _children--) : null,
              onIncrement: (_adults + _children) < _maxGuests ? () => setState(() => _children++) : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
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
          ],
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
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
        IconButton(onPressed: onDecrement, icon: const Icon(Icons.remove_circle_outline)),
        SizedBox(width: 28, child: Text('$value', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
        IconButton(onPressed: onIncrement, icon: const Icon(Icons.add_circle_outline)),
      ],
    );
  }
}
