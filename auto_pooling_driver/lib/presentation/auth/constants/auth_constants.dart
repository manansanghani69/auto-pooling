class AuthConstants {
  const AuthConstants._();

  static const String countryCode = '+91';
  static const String driverRole = 'driver';
  static const int phoneNumberLength = 10;
  static const int otpLength = 4;
}

class AuthFormatters {
  const AuthFormatters._();

  static String normalizePhoneNumber(String value) {
    final RegExp nonDigits = RegExp(r'\D');
    return value.replaceAll(nonDigits, '');
  }

  static String formatPhoneNumber(String value) {
    final String digits = normalizePhoneNumber(value);
    if (digits.length <= 5) {
      return digits;
    }

    return '${digits.substring(0, 5)} ${digits.substring(5)}';
  }

  static String formatPhoneWithCountry(String value) {
    final String formattedPhone = formatPhoneNumber(value);
    if (formattedPhone.isEmpty) {
      return AuthConstants.countryCode;
    }

    return '${AuthConstants.countryCode} $formattedPhone';
  }

  static String formatSeconds(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    final String paddedMinutes = minutes.toString().padLeft(2, '0');
    final String paddedSeconds = seconds.toString().padLeft(2, '0');
    return '$paddedMinutes:$paddedSeconds';
  }
}
