import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../utils/format.dart';

/// Write a review for a Completed booking. Receives the [Booking] via route
/// arguments; on submit it flags the booking as reviewed and appends a
/// [Review] to the matching experience's review list.
class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 5;
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _submit(Booking booking, AppLocalizations l10n) {
    // Capture messenger/navigator before pop so we never touch a deactivated
    // context after the route is removed.
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    booking.reviewLeft = true;
    final matches = experiences.where((e) => e.title == booking.experienceTitle);
    if (matches.isNotEmpty) {
      matches.first.reviewsList.add(Review(
        '${currentUser.firstName} ${currentUser.lastName}'.trim(),
        '🌍',
        _rating,
        _text.text.trim().isEmpty ? 'Great experience!' : _text.text.trim(),
        formatDate(DateTime.now()),
        isSubscriber: userSubscription != null,
      ));
    }

    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.reviewSubmitted)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final booking = ModalRoute.of(context)!.settings.arguments as Booking;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.writeReview)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              booking.experienceTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(l10n.yourRating, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                (i) => IconButton(
                  onPressed: () => setState(() => _rating = i + 1),
                  icon: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: RihlaColors.gold,
                    size: 36,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _text,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.yourReview,
                hintText: l10n.reviewHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => _submit(booking, l10n),
              child: Text(l10n.submit),
            ),
          ],
        ),
      ),
    );
  }
}
