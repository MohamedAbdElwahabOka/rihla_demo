import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Rihla'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your gateway to the Red Sea'**
  String get tagline;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @restaurants.
  ///
  /// In en, this message translates to:
  /// **'Top Restaurants'**
  String get restaurants;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search experiences...'**
  String get searchHint;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortRelevance.
  ///
  /// In en, this message translates to:
  /// **'Relevance'**
  String get sortRelevance;

  /// No description provided for @sortTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get sortTopRated;

  /// No description provided for @sortPriceLow.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceLow;

  /// No description provided for @sortPriceHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceHigh;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No experiences found'**
  String get noResults;

  /// No description provided for @resultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} experiences in Hurghada.'**
  String resultsCount(int count);

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @priceRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRangeLabel;

  /// No description provided for @noResultsHelp.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search term'**
  String get noResultsHelp;

  /// No description provided for @showResultsCount.
  ///
  /// In en, this message translates to:
  /// **'Show {count} results'**
  String showResultsCount(int count);

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @included.
  ///
  /// In en, this message translates to:
  /// **'What\'s Included'**
  String get included;

  /// No description provided for @itinerary.
  ///
  /// In en, this message translates to:
  /// **'Itinerary'**
  String get itinerary;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get readLess;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get linkCopied;

  /// No description provided for @photoIndicator.
  ///
  /// In en, this message translates to:
  /// **'Photo {current} of {total}'**
  String photoIndicator(int current, int total);

  /// No description provided for @hotelPickup.
  ///
  /// In en, this message translates to:
  /// **'Hotel pickup'**
  String get hotelPickup;

  /// No description provided for @freeCancellation.
  ///
  /// In en, this message translates to:
  /// **'Free cancellation'**
  String get freeCancellation;

  /// No description provided for @subscriberBadge.
  ///
  /// In en, this message translates to:
  /// **'Subscriber'**
  String get subscriberBadge;

  /// No description provided for @chooseDateTime.
  ///
  /// In en, this message translates to:
  /// **'Choose a date and time'**
  String get chooseDateTime;

  /// No description provided for @adults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get adults;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @spotsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} spots left'**
  String spotsLeft(int count);

  /// No description provided for @soldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold out'**
  String get soldOut;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @primaryPhone.
  ///
  /// In en, this message translates to:
  /// **'Primary Phone'**
  String get primaryPhone;

  /// No description provided for @backupPhone.
  ///
  /// In en, this message translates to:
  /// **'Backup Phone'**
  String get backupPhone;

  /// No description provided for @hotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel Name'**
  String get hotel;

  /// No description provided for @specialRequests.
  ///
  /// In en, this message translates to:
  /// **'Special Requests'**
  String get specialRequests;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @payVendorNotice.
  ///
  /// In en, this message translates to:
  /// **'No payment is processed through Rihla. Total price is due directly to the vendor in cash or via their payment system upon arrival.'**
  String get payVendorNotice;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @creditNote.
  ///
  /// In en, this message translates to:
  /// **'Using your {type} credit — {remaining} remaining after this booking'**
  String creditNote(String type, int remaining);

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @bookingSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Booking Submitted!'**
  String get bookingSubmitted;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download Ticket'**
  String get download;

  /// No description provided for @shareWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Share via WhatsApp'**
  String get shareWhatsapp;

  /// No description provided for @addCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to Calendar'**
  String get addCalendar;

  /// No description provided for @bookAnother.
  ///
  /// In en, this message translates to:
  /// **'Book Another Experience'**
  String get bookAnother;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @referenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking Reference'**
  String get referenceLabel;

  /// No description provided for @ticketNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Ticket Number'**
  String get ticketNumberLabel;

  /// No description provided for @paymentDueNotice.
  ///
  /// In en, this message translates to:
  /// **'Payment due directly to vendor upon arrival.'**
  String get paymentDueNotice;

  /// No description provided for @totalTrips.
  ///
  /// In en, this message translates to:
  /// **'Total Trips'**
  String get totalTrips;

  /// No description provided for @reviewsWritten.
  ///
  /// In en, this message translates to:
  /// **'Reviews Written'**
  String get reviewsWritten;

  /// No description provided for @activeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Active Subscription'**
  String get activeSubscription;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirm;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @mySubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get mySubscription;

  /// No description provided for @subscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get subscriptionPlans;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Saved Payment Methods'**
  String get paymentMethods;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String daysLeft(int days);

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @cancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get cancelConfirm;

  /// No description provided for @discountApplied.
  ///
  /// In en, this message translates to:
  /// **'Subscription discount applied: -{pct}%'**
  String discountApplied(int pct);

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @creditsRemainingHeader.
  ///
  /// In en, this message translates to:
  /// **'Credits Remaining'**
  String get creditsRemainingHeader;

  /// No description provided for @creditRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} remaining'**
  String creditRemaining(int count);

  /// No description provided for @creditUsed.
  ///
  /// In en, this message translates to:
  /// **'0 — used'**
  String get creditUsed;

  /// No description provided for @refundRequest.
  ///
  /// In en, this message translates to:
  /// **'Refund Request'**
  String get refundRequest;

  /// No description provided for @purchaseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Purchase {plan} for {price}?'**
  String purchaseConfirm(String plan, String price);

  /// No description provided for @purchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Subscription purchased!'**
  String get purchaseSuccess;

  /// No description provided for @validity.
  ///
  /// In en, this message translates to:
  /// **'{days} days validity'**
  String validity(int days);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCard;

  /// No description provided for @cardEndingIn.
  ///
  /// In en, this message translates to:
  /// **'{brand} ending in {last4}'**
  String cardEndingIn(String brand, String last4);

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @expiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get expiry;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @refundReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get refundReasonLabel;

  /// No description provided for @explanation.
  ///
  /// In en, this message translates to:
  /// **'Detailed Explanation'**
  String get explanation;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @refundReceived.
  ///
  /// In en, this message translates to:
  /// **'Refund request received'**
  String get refundReceived;

  /// No description provided for @reasonNotSatisfied.
  ///
  /// In en, this message translates to:
  /// **'Not satisfied with service'**
  String get reasonNotSatisfied;

  /// No description provided for @reasonChangedPlans.
  ///
  /// In en, this message translates to:
  /// **'Changed travel plans'**
  String get reasonChangedPlans;

  /// No description provided for @reasonFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial reasons'**
  String get reasonFinancial;

  /// No description provided for @reasonTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical issue'**
  String get reasonTechnical;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reasonOther;

  /// No description provided for @noActivePlan.
  ///
  /// In en, this message translates to:
  /// **'No active plan'**
  String get noActivePlan;

  /// No description provided for @subscriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'You need an active subscription to book. Choose a plan to continue.'**
  String get subscriptionRequired;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing payment...'**
  String get processingPayment;

  /// No description provided for @enterPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enterPhoneTitle;

  /// No description provided for @enterPhoneBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll text you a verification code to continue.'**
  String get enterPhoneBody;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @sendingCode.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get sendingCode;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Code sent to {phone}'**
  String codeSentTo(String phone);

  /// No description provided for @authPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'We\'ll only use this number to send your booking updates.'**
  String get authPrivacyNote;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileBody.
  ///
  /// In en, this message translates to:
  /// **'Just your name so we know who\'s booking.'**
  String get completeProfileBody;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get otpTitle;

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'Demo code: 123456 (try 000000 to see an expired code)'**
  String get otpHint;

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'This code has expired — please resend'**
  String get otpExpired;

  /// No description provided for @otpRemaining.
  ///
  /// In en, this message translates to:
  /// **'You have {count} OTP requests remaining today'**
  String otpRemaining(Object count);

  /// No description provided for @otpLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily OTP limit reached. Try again tomorrow.'**
  String get otpLimitReached;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @stepPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get stepPhone;

  /// No description provided for @stepCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get stepCode;

  /// No description provided for @phoneHeadline.
  ///
  /// In en, this message translates to:
  /// **'What\'s your number?'**
  String get phoneHeadline;

  /// No description provided for @phoneSubline.
  ///
  /// In en, this message translates to:
  /// **'We\'ll text you a code to verify it\'s you.'**
  String get phoneSubline;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// No description provided for @searchCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get searchCountryHint;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to {number}'**
  String otpSentTo(String number);

  /// No description provided for @otpRequestsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} requests left today'**
  String otpRequestsLeft(int count);

  /// No description provided for @otpDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily limit reached'**
  String get otpDailyLimit;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend available in {time}'**
  String resendIn(String time);

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @countryEgypt.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get countryEgypt;

  /// No description provided for @countryGermany.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryGermany;

  /// No description provided for @countryRussia.
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get countryRussia;

  /// No description provided for @countryUk.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryUk;

  /// No description provided for @countryFrance.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFrance;

  /// No description provided for @countryItaly.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get countryItaly;

  /// No description provided for @countrySpain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countrySpain;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReview;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRating;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// No description provided for @reviewHint.
  ///
  /// In en, this message translates to:
  /// **'Share details of your experience to help other travelers.'**
  String get reviewHint;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted. Thank you!'**
  String get reviewSubmitted;

  /// No description provided for @signInRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInRequiredTitle;

  /// No description provided for @signInRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Create an account or sign in to use this feature.'**
  String get signInRequiredBody;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @guestModeTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re browsing as a guest'**
  String get guestModeTitle;

  /// No description provided for @guestModeBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to book experiences, save favorites, and manage your trips.'**
  String get guestModeBody;

  /// No description provided for @splashLocation.
  ///
  /// In en, this message translates to:
  /// **'Hurghada, Red Sea'**
  String get splashLocation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
