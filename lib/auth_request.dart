/// Carried from the Auth screen to OTP entry via route `arguments`.
class AuthRequest {
  final bool isRegister;
  final String countryCode;
  final String phone;
  final String fullName;

  const AuthRequest({
    required this.isRegister,
    required this.countryCode,
    required this.phone,
    this.fullName = '',
  });
}
