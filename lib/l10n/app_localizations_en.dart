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

  @override
  String get chooseDateTime => 'Choose a date and time';

  @override
  String get adults => 'Adults';

  @override
  String get children => 'Children';

  @override
  String spotsLeft(int count) {
    return '$count spots left';
  }

  @override
  String get soldOut => 'Sold out';

  @override
  String get continueLabel => 'Continue';

  @override
  String get contactDetails => 'Contact Details';

  @override
  String get fullName => 'Full Name';

  @override
  String get primaryPhone => 'Primary Phone';

  @override
  String get backupPhone => 'Backup Phone';

  @override
  String get hotel => 'Hotel Name';

  @override
  String get specialRequests => 'Special Requests';

  @override
  String get email => 'Email';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get payVendorNotice =>
      'No payment is processed through Rihla. Total price is due directly to the vendor in cash or via their payment system upon arrival.';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String creditNote(String type, int remaining) {
    return 'Using your $type credit — $remaining remaining after this booking';
  }

  @override
  String get total => 'Total';

  @override
  String get bookingSubmitted => 'Booking Submitted!';

  @override
  String get download => 'Download Ticket';

  @override
  String get shareWhatsapp => 'Share via WhatsApp';

  @override
  String get addCalendar => 'Add to Calendar';

  @override
  String get bookAnother => 'Book Another Experience';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get referenceLabel => 'Booking Reference';

  @override
  String get ticketNumberLabel => 'Ticket Number';

  @override
  String get paymentDueNotice => 'Payment due directly to vendor upon arrival.';

  @override
  String get totalTrips => 'Total Trips';

  @override
  String get reviewsWritten => 'Reviews Written';

  @override
  String get activeSubscription => 'Active Subscription';

  @override
  String get settings => 'Settings';

  @override
  String get signOut => 'Sign Out';

  @override
  String get cancel => 'Cancel';

  @override
  String get signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get mySubscription => 'My Subscription';

  @override
  String get subscriptionPlans => 'Subscription Plans';

  @override
  String get paymentMethods => 'Saved Payment Methods';

  @override
  String get notifications => 'Notifications';

  @override
  String daysLeft(int days) {
    return '$days days left';
  }

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get cancelConfirm => 'Are you sure you want to cancel this booking?';

  @override
  String discountApplied(int pct) {
    return 'Subscription discount applied: -$pct%';
  }

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get active => 'Active';

  @override
  String get purchaseDate => 'Purchase Date';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get creditsRemainingHeader => 'Credits Remaining';

  @override
  String creditRemaining(int count) {
    return '$count remaining';
  }

  @override
  String get creditUsed => '0 — used';

  @override
  String get refundRequest => 'Refund Request';

  @override
  String purchaseConfirm(String plan, String price) {
    return 'Purchase $plan for $price?';
  }

  @override
  String get purchaseSuccess => 'Subscription purchased!';

  @override
  String validity(int days) {
    return '$days days validity';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get addCard => 'Add Card';

  @override
  String cardEndingIn(String brand, String last4) {
    return '$brand ending in $last4';
  }

  @override
  String get cardNumber => 'Card Number';

  @override
  String get expiry => 'Expiry';

  @override
  String get cvv => 'CVV';

  @override
  String get add => 'Add';

  @override
  String get refundReasonLabel => 'Cancellation Reason';

  @override
  String get explanation => 'Detailed Explanation';

  @override
  String get submit => 'Submit';

  @override
  String get refundReceived => 'Refund request received';

  @override
  String get reasonNotSatisfied => 'Not satisfied with service';

  @override
  String get reasonChangedPlans => 'Changed travel plans';

  @override
  String get reasonFinancial => 'Financial reasons';

  @override
  String get reasonTechnical => 'Technical issue';

  @override
  String get reasonOther => 'Other';

  @override
  String get noActivePlan => 'No active plan';

  @override
  String get subscriptionRequired =>
      'You need an active subscription to book. Choose a plan to continue.';

  @override
  String get processingPayment => 'Processing payment...';

  @override
  String get register => 'Register';

  @override
  String get login => 'Login';

  @override
  String get sendCode => 'Send Code';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get otpTitle => 'Enter verification code';

  @override
  String get otpHint => 'Demo code: 123456 (try 000000 to see an expired code)';

  @override
  String get otpExpired => 'This code has expired — please resend';

  @override
  String otpRemaining(Object count) {
    return 'You have $count OTP requests remaining today';
  }

  @override
  String get otpLimitReached => 'Daily OTP limit reached. Try again tomorrow.';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get numberNotRegistered =>
      'This number isn\'t registered. Please register first.';

  @override
  String get countryEgypt => 'Egypt';

  @override
  String get countryGermany => 'Germany';

  @override
  String get countryRussia => 'Russia';
}
