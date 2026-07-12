// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Rihla';

  @override
  String get navHome => 'Start';

  @override
  String get navExplore => 'Entdecken';

  @override
  String get navBookings => 'Buchungen';

  @override
  String get navProfile => 'Profil';

  @override
  String get language => 'Sprache';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get signIn => 'Anmelden';

  @override
  String get tagline => 'Ihr Tor zum Roten Meer';

  @override
  String get greetingMorning => 'Guten Morgen';

  @override
  String get greetingAfternoon => 'Guten Tag';

  @override
  String get greetingEvening => 'Guten Abend';

  @override
  String get featured => 'Empfohlen';

  @override
  String get popular => 'Beliebt';

  @override
  String get restaurants => 'Top-Restaurants';

  @override
  String get searchHint => 'Erlebnisse suchen...';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get sortRelevance => 'Relevanz';

  @override
  String get sortTopRated => 'Am besten bewertet';

  @override
  String get sortPriceLow => 'Preis: aufsteigend';

  @override
  String get sortPriceHigh => 'Preis: absteigend';

  @override
  String get sortNewest => 'Neueste';

  @override
  String get noResults => 'Keine Erlebnisse gefunden';

  @override
  String resultsCount(int count) {
    return '$count Erlebnisse in Hurghada.';
  }

  @override
  String get about => 'Über';

  @override
  String get included => 'Inklusive Leistungen';

  @override
  String get itinerary => 'Reiseverlauf';

  @override
  String get reviews => 'Bewertungen';

  @override
  String get readMore => 'Mehr lesen';

  @override
  String get readLess => 'Weniger anzeigen';

  @override
  String get book => 'Buchen';

  @override
  String get linkCopied => 'Link in die Zwischenablage kopiert';
}
