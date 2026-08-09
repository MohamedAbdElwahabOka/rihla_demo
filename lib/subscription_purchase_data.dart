import 'mock_data.dart';

/// Carried forward via route `arguments` through the subscription purchase
/// flow (Plans → Review → Result) — no global state, same approach as
/// [BookingData] for the booking flow.
class SubscriptionPurchaseData {
  final SubscriptionPlan plan;
  int adults;
  int children;
  String? promoCode;
  int promoDiscountPct;

  SubscriptionPurchaseData({
    required this.plan,
    this.adults = 1,
    this.children = 0,
    this.promoCode,
    this.promoDiscountPct = 0,
  });
}
