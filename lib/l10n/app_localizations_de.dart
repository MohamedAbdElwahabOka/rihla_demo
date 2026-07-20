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
  String get invalidPhoneNumber => 'Bitte eine gültige Telefonnummer eingeben';

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

  @override
  String get totalTrips => 'Gesamtreisen';

  @override
  String get reviewsWritten => 'Verfasste Bewertungen';

  @override
  String get activeSubscription => 'Aktives Abonnement';

  @override
  String get settings => 'Einstellungen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get signOutConfirm => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get myBookings => 'Meine Buchungen';

  @override
  String get mySubscription => 'Mein Abonnement';

  @override
  String get subscriptionPlans => 'Abo-Pläne';

  @override
  String get paymentMethods => 'Gespeicherte Zahlungsmethoden';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String daysLeft(int days) {
    return '$days Tage verbleibend';
  }

  @override
  String get cancelBooking => 'Buchung stornieren';

  @override
  String get cancelConfirm => 'Möchten Sie diese Buchung wirklich stornieren?';

  @override
  String discountApplied(int pct) {
    return 'Abo-Rabatt angewendet: -$pct%';
  }

  @override
  String get statusCancelled => 'Storniert';

  @override
  String get statusCompleted => 'Abgeschlossen';

  @override
  String get active => 'Aktiv';

  @override
  String get purchaseDate => 'Kaufdatum';

  @override
  String get expiryDate => 'Ablaufdatum';

  @override
  String get creditsRemainingHeader => 'Verbleibende Guthaben';

  @override
  String creditRemaining(int count) {
    return '$count verbleibend';
  }

  @override
  String get creditUsed => '0 — verbraucht';

  @override
  String get refundRequest => 'Rückerstattungsantrag';

  @override
  String purchaseConfirm(String plan, String price) {
    return '$plan für $price kaufen?';
  }

  @override
  String get purchaseSuccess => 'Abonnement gekauft!';

  @override
  String validity(int days) {
    return '$days Tage Gültigkeit';
  }

  @override
  String get confirm => 'Bestätigen';

  @override
  String get addCard => 'Karte hinzufügen';

  @override
  String cardEndingIn(String brand, String last4) {
    return '$brand endet auf $last4';
  }

  @override
  String get cardNumber => 'Kartennummer';

  @override
  String get expiry => 'Ablaufdatum';

  @override
  String get cvv => 'CVV';

  @override
  String get add => 'Hinzufügen';

  @override
  String get refundReasonLabel => 'Stornierungsgrund';

  @override
  String get explanation => 'Ausführliche Erklärung';

  @override
  String get submit => 'Absenden';

  @override
  String get refundReceived => 'Rückerstattungsantrag eingegangen';

  @override
  String get reasonNotSatisfied => 'Nicht zufrieden mit dem Service';

  @override
  String get reasonChangedPlans => 'Reisepläne geändert';

  @override
  String get reasonFinancial => 'Finanzielle Gründe';

  @override
  String get reasonTechnical => 'Technisches Problem';

  @override
  String get reasonOther => 'Sonstiges';

  @override
  String get noActivePlan => 'Kein aktives Abo';

  @override
  String get subscriptionRequired =>
      'Sie benötigen ein aktives Abonnement, um zu buchen. Wählen Sie einen Plan, um fortzufahren.';

  @override
  String get processingPayment => 'Zahlung wird verarbeitet...';

  @override
  String get enterPhoneTitle => 'Telefonnummer eingeben';

  @override
  String get enterPhoneBody =>
      'Wir senden Ihnen einen Bestätigungscode per SMS.';

  @override
  String get sendCode => 'Code senden';

  @override
  String get sendingCode => 'Wird gesendet…';

  @override
  String codeSentTo(String phone) {
    return 'Code gesendet an $phone';
  }

  @override
  String get authPrivacyNote =>
      'Wir verwenden diese Nummer nur, um Sie über Ihre Buchungen zu informieren.';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get completeProfileTitle => 'Profil vervollständigen';

  @override
  String get completeProfileBody =>
      'Nur Ihr Name, damit wir wissen, wer bucht.';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get otpTitle => 'Bestätigungscode eingeben';

  @override
  String get otpHint =>
      'Demo-Code: 123456 (versuchen Sie 000000 für einen abgelaufenen Code)';

  @override
  String get otpExpired => 'Dieser Code ist abgelaufen — bitte erneut senden';

  @override
  String otpRemaining(Object count) {
    return 'Sie haben heute noch $count OTP-Anfragen übrig';
  }

  @override
  String get otpLimitReached =>
      'Tägliches OTP-Limit erreicht. Versuchen Sie es morgen erneut.';

  @override
  String get resendCode => 'Code erneut senden';

  @override
  String get countryEgypt => 'Ägypten';

  @override
  String get countryGermany => 'Deutschland';

  @override
  String get countryRussia => 'Russland';

  @override
  String get countryUk => 'Vereinigtes Königreich';

  @override
  String get countryFrance => 'Frankreich';

  @override
  String get countryItaly => 'Italien';

  @override
  String get countrySpain => 'Spanien';

  @override
  String get writeReview => 'Bewertung schreiben';

  @override
  String get yourRating => 'Ihre Bewertung';

  @override
  String get yourReview => 'Ihre Rezension';

  @override
  String get reviewHint =>
      'Teilen Sie Details Ihres Erlebnisses, um anderen Reisenden zu helfen.';

  @override
  String get reviewSubmitted => 'Bewertung gesendet. Vielen Dank!';

  @override
  String get signInRequiredTitle => 'Zum Fortfahren anmelden';

  @override
  String get signInRequiredBody =>
      'Erstellen Sie ein Konto oder melden Sie sich an, um diese Funktion zu nutzen.';

  @override
  String get notNow => 'Nicht jetzt';

  @override
  String get guestModeTitle => 'Sie surfen als Gast';

  @override
  String get guestModeBody =>
      'Melden Sie sich an, um Erlebnisse zu buchen, Favoriten zu speichern und Ihre Reisen zu verwalten.';

  @override
  String get splashLocation => 'Hurghada, Rotes Meer';
}
