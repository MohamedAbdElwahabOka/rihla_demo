import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Models (plain Dart — no fromJson; all content authored directly below).
// ---------------------------------------------------------------------------

enum BookingStatus { confirmed, completed, cancelled }

class ItineraryStop {
  final String time;
  final String description;
  const ItineraryStop(this.time, this.description);
}

class Review {
  final String reviewerName;
  final String countryFlag;
  final int rating;
  final String text;
  final String date;
  final bool isSubscriber;
  const Review(
    this.reviewerName,
    this.countryFlag,
    this.rating,
    this.text,
    this.date, {
    this.isSubscriber = false,
  });
}

class Experience {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String difficulty;
  final String about;
  final double rating;
  final int reviewCount;
  final int priceOriginal;
  final int priceDiscounted;
  final IconData icon;
  final List<String> included;
  final List<String> excluded;
  final List<ItineraryStop> itinerary;
  final List<Review> reviewsList;
  final String? badge; // BESTSELLER, NEW, DEAL, or null
  final bool freeCancellation;
  final bool hotelPickup;
  final String languages;

  const Experience({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.about,
    required this.rating,
    required this.reviewCount,
    required this.priceOriginal,
    required this.priceDiscounted,
    required this.icon,
    required this.included,
    required this.excluded,
    required this.itinerary,
    required this.reviewsList,
    this.badge,
    this.freeCancellation = true,
    this.hotelPickup = true,
    this.languages = 'English, German, Russian',
  });
}

class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final List<String> badges; // HALAL, VEGETARIAN, OPEN NOW
  final IconData icon;
  final String priceRange; // €, €€, €€€

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.badges,
    required this.icon,
    required this.priceRange,
  });
}

class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final int priceEur;
  final int validityDays;
  final Map<String, int> credits; // typed credit name -> count

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.priceEur,
    required this.validityDays,
    required this.credits,
  });
}

class UserSubscription {
  final SubscriptionPlan plan;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  Map<String, int> creditsRemaining;
  bool active;

  UserSubscription({
    required this.plan,
    required this.purchaseDate,
    required this.expiryDate,
    required this.creditsRemaining,
    this.active = true,
  });
}

class Booking {
  final String id;
  final String experienceTitle;
  final IconData icon;
  final DateTime date;
  final String time;
  final int adults;
  final int children;
  final int discountPct;
  final int originalPriceEur;
  final int finalPriceEur;
  final String refCode;
  final String ticketNumber;
  final String? creditTypeConsumed;
  BookingStatus status;
  bool reviewLeft;

  Booking({
    required this.id,
    required this.experienceTitle,
    required this.icon,
    required this.date,
    required this.time,
    required this.adults,
    required this.children,
    required this.discountPct,
    required this.originalPriceEur,
    required this.finalPriceEur,
    required this.refCode,
    required this.ticketNumber,
    this.creditTypeConsumed,
    this.status = BookingStatus.confirmed,
    this.reviewLeft = false,
  });
}

class AppNotification {
  final String id;
  final IconData icon;
  final String title;
  final String body;
  final String relativeTime;
  bool unread;

  AppNotification({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    required this.relativeTime,
    this.unread = true,
  });
}

class PaymentMethod {
  final String id;
  final String brand;
  final String last4;
  const PaymentMethod({required this.id, required this.brand, required this.last4});
}

class TimeSlot {
  final String time;
  final int spotsLeft; // 0 = sold out
  const TimeSlot(this.time, this.spotsLeft);
}

class WeatherSnapshot {
  final String city;
  final int tempC;
  final String condition;
  final int windKmh;
  const WeatherSnapshot({
    required this.city,
    required this.tempC,
    required this.condition,
    required this.windKmh,
  });
}

class UserProfile {
  final String firstName;
  final String lastName;
  final String countryCode;
  final String phone;
  final String? email;
  final int totalTrips;
  final int reviewsWritten;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.phone,
    this.email,
    required this.totalTrips,
    required this.reviewsWritten,
  });
}

// ---------------------------------------------------------------------------
// Reference lists (FR-016 Home categories, FR-059 Explore chips, FR-061 sort)
// ---------------------------------------------------------------------------

const homeCategories = <String>[
  'Diving',
  'Desert Safari',
  'Snorkeling',
  'Boat Tours',
  'Seafood',
  'Giftun Islands',
  'Quad Biking',
  'Spa & Wellness',
  'Nightlife',
  'Cultural',
];

const exploreFilterChips = <String>[
  'All',
  'Diving',
  'Desert',
  'Snorkel',
  'Restaurants',
  'Boat Tours',
  'Wellness',
  'Cultural',
];

const sortOptions = <String>[
  'Relevance',
  'Top Rated',
  'Price: Low-High',
  'Price: High-Low',
  'Newest',
];

// ---------------------------------------------------------------------------
// Seed data
// ---------------------------------------------------------------------------

const currentWeather = WeatherSnapshot(city: 'Hurghada', tempC: 29, condition: 'Good visibility', windKmh: 12);

const timeSlots = <TimeSlot>[
  TimeSlot('08:00', 5),
  TimeSlot('10:00', 3),
  TimeSlot('12:00', 0),
  TimeSlot('14:00', 8),
  TimeSlot('16:00', 2),
  TimeSlot('18:00', 0),
];

const currentUser = UserProfile(
  firstName: 'Ahmed',
  lastName: 'Youssef',
  countryCode: '+20',
  phone: '100 123 4567',
  email: 'ahmed.youssef@example.com',
  totalTrips: 4,
  reviewsWritten: 2,
);

const experiences = <Experience>[
  Experience(
    id: 'e1',
    title: 'Giftun Island Snorkeling',
    category: 'Snorkeling',
    duration: '6h',
    difficulty: 'Easy',
    about:
        'Full-day boat trip to the Giftun islands with two snorkeling stops and '
        'lunch aboard. Calm, shallow reefs make this a favorite for first-time '
        'snorkelers and families alike.',
    rating: 4.8,
    reviewCount: 214,
    priceOriginal: 45,
    priceDiscounted: 32,
    icon: Icons.scuba_diving,
    badge: 'BESTSELLER',
    included: ['Hotel pickup', 'Lunch aboard', 'Snorkel gear', 'Marine park fee'],
    excluded: ['Drinks', 'Tips'],
    itinerary: [
      ItineraryStop('08:00', 'Hotel pickup'),
      ItineraryStop('09:30', 'First reef stop'),
      ItineraryStop('12:00', 'Lunch aboard'),
      ItineraryStop('14:00', 'Second reef stop'),
      ItineraryStop('16:30', 'Return to hotel'),
    ],
    reviewsList: [
      Review('Lena K.', '🇩🇪', 5, 'Crystal clear water and the crew was fantastic with our kids.', '02/06/2026'),
      Review('Oleg P.', '🇷🇺', 4, 'Great trip, lunch could be better.', '18/05/2026', isSubscriber: true),
    ],
  ),
  Experience(
    id: 'e2',
    title: 'Red Sea Wreck Diving',
    category: 'Diving',
    duration: '8h',
    difficulty: 'Advanced',
    about:
        'Two-tank dive to the famous Red Sea wrecks for certified divers, with a '
        'dive guide and full equipment rental included.',
    rating: 4.9,
    reviewCount: 176,
    priceOriginal: 90,
    priceDiscounted: 68,
    icon: Icons.water,
    badge: 'DEAL',
    included: ['Hotel pickup', 'Full dive gear', 'Dive guide', 'Lunch'],
    excluded: ['Dive certification fees', 'Underwater camera rental'],
    itinerary: [
      ItineraryStop('07:00', 'Hotel pickup'),
      ItineraryStop('08:30', 'Boat departure'),
      ItineraryStop('09:30', 'First dive'),
      ItineraryStop('12:00', 'Surface interval & lunch'),
      ItineraryStop('13:30', 'Second dive'),
      ItineraryStop('16:00', 'Return to hotel'),
    ],
    reviewsList: [
      Review('James T.', '🇬🇧', 5, 'Incredible wreck, visibility was 20m+.', '30/05/2026'),
    ],
  ),
  Experience(
    id: 'e3',
    title: 'Desert Safari & Bedouin Dinner',
    category: 'Desert Safari',
    duration: '5h',
    difficulty: 'Moderate',
    about:
        'Quad or 4x4 desert adventure through the Eastern desert, followed by a '
        'traditional Bedouin dinner under the stars with tea and storytelling.',
    rating: 4.7,
    reviewCount: 302,
    priceOriginal: 38,
    priceDiscounted: 27,
    icon: Icons.terrain,
    badge: 'BESTSELLER',
    included: ['Hotel pickup', 'Safety briefing', 'Bedouin dinner', 'Tea ceremony'],
    excluded: ['Alcoholic drinks', 'Tips for guides'],
    itinerary: [
      ItineraryStop('16:00', 'Hotel pickup'),
      ItineraryStop('17:00', 'Desert arrival & briefing'),
      ItineraryStop('17:30', 'Dune driving'),
      ItineraryStop('19:00', 'Bedouin camp & dinner'),
      ItineraryStop('21:00', 'Return to hotel'),
    ],
    reviewsList: [
      Review('Sofia R.', '🇪🇸', 5, 'Sunset over the dunes was unforgettable.', '10/06/2026'),
      Review('Marta B.', '🇩🇪', 4, 'Fun but a bit bumpy for younger kids.', '22/05/2026'),
    ],
  ),
  Experience(
    id: 'e4',
    title: "Dolphin House Boat Trip",
    category: 'Boat Tours',
    duration: '7h',
    difficulty: 'Easy',
    about:
        "Sail to Dolphin House (Sha'ab Samadai) for a chance to swim near wild "
        'spinner dolphins in their natural reef habitat.',
    rating: 4.6,
    reviewCount: 158,
    priceOriginal: 42,
    priceDiscounted: 30,
    icon: Icons.sailing,
    badge: 'NEW',
    included: ['Hotel pickup', 'Lunch aboard', 'Snorkel gear'],
    excluded: ['Drinks', 'Wetsuit rental'],
    itinerary: [
      ItineraryStop('07:30', 'Hotel pickup'),
      ItineraryStop('09:00', "Departure to Sha'ab Samadai"),
      ItineraryStop('10:30', 'Dolphin watching & swimming'),
      ItineraryStop('13:00', 'Lunch aboard'),
      ItineraryStop('15:30', 'Return to marina'),
    ],
    reviewsList: [
      Review('Youssef A.', '🇪🇬', 5, 'Saw a pod of over 20 dolphins, amazing!', '15/06/2026'),
    ],
  ),
  Experience(
    id: 'e5',
    title: 'Quad Biking Desert Adventure',
    category: 'Quad Biking',
    duration: '3h',
    difficulty: 'Moderate',
    about:
        'Ride your own quad bike through the desert dunes with an experienced '
        'guide, ending with tea at a Bedouin camp.',
    rating: 4.5,
    reviewCount: 121,
    priceOriginal: 30,
    priceDiscounted: 22,
    icon: Icons.two_wheeler,
    included: ['Hotel pickup', 'Quad bike & fuel', 'Safety gear', 'Tea at camp'],
    excluded: ['Photos/videos', 'Tips'],
    itinerary: [
      ItineraryStop('08:00', 'Hotel pickup'),
      ItineraryStop('09:00', 'Safety briefing'),
      ItineraryStop('09:30', 'Quad ride begins'),
      ItineraryStop('11:00', 'Bedouin camp tea stop'),
      ItineraryStop('12:00', 'Return to hotel'),
    ],
    reviewsList: [
      Review('Tom H.', '🇬🇧', 4, 'Great fun, dusty but worth it.', '28/05/2026'),
    ],
  ),
  Experience(
    id: 'e6',
    title: 'Hurghada Spa & Wellness Day',
    category: 'Spa & Wellness',
    duration: '4h',
    difficulty: 'Easy',
    about:
        'A relaxing half-day spa package with a Red Sea salt scrub, massage, and '
        'access to the pool and relaxation lounge.',
    rating: 4.9,
    reviewCount: 89,
    priceOriginal: 55,
    priceDiscounted: 40,
    icon: Icons.spa,
    badge: 'DEAL',
    included: ['Salt scrub', 'Massage (60 min)', 'Pool & lounge access', 'Herbal tea'],
    excluded: ['Additional treatments', 'Transport'],
    itinerary: [
      ItineraryStop('10:00', 'Check-in & welcome tea'),
      ItineraryStop('10:30', 'Red Sea salt scrub'),
      ItineraryStop('11:30', 'Massage'),
      ItineraryStop('12:30', 'Pool & lounge relaxation'),
      ItineraryStop('14:00', 'Session ends'),
    ],
    reviewsList: [
      Review('Anna M.', '🇷🇺', 5, 'Exactly what I needed after a week of diving.', '05/06/2026', isSubscriber: true),
    ],
  ),
];

const restaurants = <Restaurant>[
  Restaurant(
    id: 'r1',
    name: 'Nemo Seafood House',
    cuisine: 'Seafood',
    rating: 4.7,
    reviewCount: 340,
    badges: ['HALAL', 'OPEN NOW'],
    icon: Icons.set_meal,
    priceRange: '€€',
  ),
  Restaurant(
    id: 'r2',
    name: 'Marina Grill & Lounge',
    cuisine: 'Grill',
    rating: 4.5,
    reviewCount: 210,
    badges: ['HALAL', 'VEGETARIAN'],
    icon: Icons.restaurant,
    priceRange: '€€€',
  ),
  Restaurant(
    id: 'r3',
    name: 'Green Garden Vegetarian',
    cuisine: 'Vegetarian',
    rating: 4.6,
    reviewCount: 98,
    badges: ['VEGETARIAN', 'OPEN NOW'],
    icon: Icons.eco,
    priceRange: '€',
  ),
];

const subscriptionPlans = <SubscriptionPlan>[
  SubscriptionPlan(
    id: 'p1',
    name: 'Red Sea Explorer',
    description: 'Discover the best of Hurghada',
    priceEur: 9,
    validityDays: 30,
    credits: {'Snorkeling': 1, 'Desert Safari': 1, 'Shopping': 1},
  ),
  SubscriptionPlan(
    id: 'p2',
    name: 'Adventure Seeker',
    description: 'For thrill-seekers who want it all',
    priceEur: 19,
    validityDays: 45,
    credits: {'Diving': 1, 'Quad Biking': 1, 'Boat Tours': 1, 'Desert Safari': 1},
  ),
  SubscriptionPlan(
    id: 'p3',
    name: 'Ultimate Explorer',
    description: 'Unlock every corner of the Red Sea',
    priceEur: 35,
    validityDays: 60,
    credits: {
      'Diving': 2,
      'Snorkeling': 2,
      'Desert Safari': 1,
      'Boat Tours': 1,
      'Spa & Wellness': 1,
    },
  ),
];

/// The mock signed-in traveler holds an active subscription so the booking
/// flow (which requires a subscription per FR-037/BR-006) is demonstrable.
final userSubscription = UserSubscription(
  plan: subscriptionPlans[0],
  purchaseDate: DateTime(2026, 6, 20),
  expiryDate: DateTime(2026, 7, 20),
  creditsRemaining: {'Snorkeling': 1, 'Desert Safari': 0, 'Shopping': 1},
);

final bookings = <Booking>[
  Booking(
    id: 'b1',
    experienceTitle: 'Giftun Island Snorkeling',
    icon: Icons.scuba_diving,
    date: DateTime(2026, 7, 20),
    time: '09:00',
    adults: 2,
    children: 1,
    discountPct: 15,
    originalPriceEur: 122,
    finalPriceEur: 104,
    refCode: 'RHL-2026-08841',
    ticketNumber: '5849-3021',
    creditTypeConsumed: 'Snorkeling',
    status: BookingStatus.confirmed,
  ),
  Booking(
    id: 'b2',
    experienceTitle: 'Desert Safari & Bedouin Dinner',
    icon: Icons.terrain,
    date: DateTime(2026, 6, 25),
    time: '16:00',
    adults: 2,
    children: 0,
    discountPct: 15,
    originalPriceEur: 76,
    finalPriceEur: 65,
    refCode: 'RHL-2026-07213',
    ticketNumber: '2041-5573',
    creditTypeConsumed: 'Desert Safari',
    status: BookingStatus.completed,
    reviewLeft: true,
  ),
  Booking(
    id: 'b3',
    experienceTitle: 'Quad Biking Desert Adventure',
    icon: Icons.two_wheeler,
    date: DateTime(2026, 6, 10),
    time: '08:00',
    adults: 1,
    children: 0,
    discountPct: 10,
    originalPriceEur: 30,
    finalPriceEur: 27,
    refCode: 'RHL-2026-06190',
    ticketNumber: '1102-9384',
    status: BookingStatus.cancelled,
  ),
];

final notifications = <AppNotification>[
  AppNotification(
    id: 'n1',
    icon: Icons.check_circle,
    title: 'Booking Confirmed',
    body: 'Your Giftun Island Snorkeling booking is confirmed for 20/07/2026.',
    relativeTime: '2h ago',
  ),
  AppNotification(
    id: 'n2',
    icon: Icons.card_giftcard,
    title: 'New Plan Available',
    body: 'Check out the new Ultimate Explorer subscription plan.',
    relativeTime: '1d ago',
  ),
  AppNotification(
    id: 'n3',
    icon: Icons.reviews,
    title: 'Leave a Review',
    body: 'How was your Desert Safari & Bedouin Dinner? Leave a review.',
    relativeTime: '2d ago',
  ),
  AppNotification(
    id: 'n4',
    icon: Icons.local_offer,
    title: 'Limited Deal',
    body: 'Hurghada Spa & Wellness Day is now on Deal pricing.',
    relativeTime: '3d ago',
    unread: false,
  ),
  AppNotification(
    id: 'n5',
    icon: Icons.wb_sunny,
    title: 'Great Diving Conditions',
    body: 'Sea visibility is excellent this week, perfect for diving.',
    relativeTime: '4d ago',
    unread: false,
  ),
  AppNotification(
    id: 'n6',
    icon: Icons.replay,
    title: 'Refund Update',
    body: 'Your refund request has been approved.',
    relativeTime: '6d ago',
    unread: false,
  ),
];

final paymentMethods = <PaymentMethod>[
  const PaymentMethod(id: 'pm1', brand: 'Visa', last4: '4242'),
  const PaymentMethod(id: 'pm2', brand: 'Mastercard', last4: '1881'),
];
