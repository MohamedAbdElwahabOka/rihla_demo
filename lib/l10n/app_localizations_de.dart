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

  @override
  String photoIndicator(int current, int total) {
    return 'Foto $current von $total';
  }

  @override
  String get hotelPickup => 'Hotelabholung';

  @override
  String get freeCancellation => 'Kostenlose Stornierung';

  @override
  String get subscriberBadge => 'Abonnent';

  @override
  String get chooseDateTime => 'Datum und Uhrzeit wählen';

  @override
  String get adults => 'Erwachsene';

  @override
  String get children => 'Kinder';

  @override
  String spotsLeft(int count) {
    return '$count Plätze frei';
  }

  @override
  String get soldOut => 'Ausgebucht';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get contactDetails => 'Kontaktdaten';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get primaryPhone => 'Haupttelefonnummer';

  @override
  String get backupPhone => 'Ausweichtelefonnummer';

  @override
  String get hotel => 'Hotelname';

  @override
  String get specialRequests => 'Besondere Wünsche';

  @override
  String get email => 'E-Mail';

  @override
  String get fieldRequired => 'Dieses Feld ist erforderlich';

  @override
  String get orderSummary => 'Bestellübersicht';

  @override
  String get payVendorNotice =>
      'Rihla verarbeitet keine Zahlungen. Der Gesamtpreis ist bei Ankunft direkt an den Anbieter in bar oder über dessen Zahlungssystem zu entrichten.';

  @override
  String get confirmBooking => 'Buchung bestätigen';

  @override
  String creditNote(String type, int remaining) {
    return 'Ihr $type-Guthaben wird verwendet — $remaining verbleibend nach dieser Buchung';
  }

  @override
  String get total => 'Gesamt';

  @override
  String get bookingSubmitted => 'Buchung übermittelt!';

  @override
  String get download => 'Ticket herunterladen';

  @override
  String get shareWhatsapp => 'Über WhatsApp teilen';

  @override
  String get addCalendar => 'Zum Kalender hinzufügen';

  @override
  String get bookAnother => 'Weiteres Erlebnis buchen';

  @override
  String get statusConfirmed => 'Bestätigt';

  @override
  String get referenceLabel => 'Buchungsreferenz';

  @override
  String get ticketNumberLabel => 'Ticketnummer';

  @override
  String get paymentDueNotice =>
      'Zahlung bei Ankunft direkt an den Anbieter fällig.';
}
