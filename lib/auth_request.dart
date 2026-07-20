/// Carried from the Auth screen to OTP entry, and on to Complete Profile if
/// the phone turns out to be unregistered, via route `arguments`.
class AuthRequest {
  final String countryCode;
  final String phone;

  const AuthRequest({
    required this.countryCode,
    required this.phone,
  });
}
