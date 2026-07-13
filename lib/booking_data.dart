import 'mock_data.dart';

/// Carried forward via route `arguments` through Booking Steps 1-3
/// (no global state, per the design's Navigator-only approach).
class BookingData {
  final Experience experience;
  DateTime? date;
  String? timeSlot;
  int adults;
  int children;

  String fullName;
  String primaryPhone;
  String backupPhone;
  String hotelName;
  String specialRequests;
  String email;

  BookingData({
    required this.experience,
    this.date,
    this.timeSlot,
    this.adults = 1,
    this.children = 0,
    this.fullName = '',
    this.primaryPhone = '',
    this.backupPhone = '',
    this.hotelName = '',
    this.specialRequests = '',
    this.email = '',
  });
}
