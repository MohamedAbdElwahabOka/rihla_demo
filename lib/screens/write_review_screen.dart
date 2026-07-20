import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/fade_in.dart';
import '../widgets/rihla_app_bar.dart';

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
      appBar: RihlaAppBar(title: Text(l10n.writeReview)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RihlaSpace.lg),
          children: [
            FadeInUp(
              child: Text(
                booking.experienceTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: RihlaSpace.xl),
            FadeInUp(
              delay: const Duration(milliseconds: 60),
              child: _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.yourRating.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: RihlaColors.inkFaint,
                      ),
                    ),
                    const SizedBox(height: RihlaSpace.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        5,
                        (i) => IconButton(
                          onPressed: () => setState(() => _rating = i + 1),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                          icon: Icon(
                            i < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                            color: RihlaColors.gold,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: RihlaSpace.lg),
            FadeInUp(
              delay: const Duration(milliseconds: 120),
              child: _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.yourReview.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: RihlaColors.inkFaint,
                      ),
                    ),
                    const SizedBox(height: RihlaSpace.md),
                    TextField(
                      controller: _text,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: l10n.reviewHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: RihlaSpace.xl),
            FadeInUp(
              delay: const Duration(milliseconds: 180),
              child: FilledButton(
                onPressed: () => _submit(booking, l10n),
                child: Text(l10n.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(RihlaSpace.lg),
      decoration: BoxDecoration(
        color: RihlaColors.surface,
        borderRadius: BorderRadius.circular(RihlaSpace.radiusLg),
        boxShadow: RihlaShadows.soft,
      ),
      child: child,
    );
  }
}
