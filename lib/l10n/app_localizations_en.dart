// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rihla';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navProfile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get getStarted => 'Get Started';

  @override
  String get signIn => 'Sign In';

  @override
  String get tagline => 'Your gateway to the Red Sea';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get featured => 'Featured';

  @override
  String get popular => 'Popular';

  @override
  String get restaurants => 'Top Restaurants';

  @override
  String get searchHint => 'Search experiences...';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortRelevance => 'Relevance';

  @override
  String get sortTopRated => 'Top Rated';

  @override
  String get sortPriceLow => 'Price: Low to High';

  @override
  String get sortPriceHigh => 'Price: High to Low';

  @override
  String get sortNewest => 'Newest';

  @override
  String get noResults => 'No experiences found';

  @override
  String resultsCount(int count) {
    return '$count experiences in Hurghada.';
  }

  @override
  String get about => 'About';

  @override
  String get included => 'What\'s Included';

  @override
  String get itinerary => 'Itinerary';

  @override
  String get reviews => 'Reviews';

  @override
  String get readMore => 'Read more';

  @override
  String get readLess => 'Read less';

  @override
  String get book => 'Book';

  @override
  String get linkCopied => 'Link copied to clipboard';

  @override
  String photoIndicator(int current, int total) {
    return 'Photo $current of $total';
  }

  @override
  String get hotelPickup => 'Hotel pickup';

  @override
  String get freeCancellation => 'Free cancellation';

  @override
  String get subscriberBadge => 'Subscriber';
}
