class PasswordValidator {
  /// Validates password based on requirements:
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one number
  /// - At least one special character
  static ValidationResult validatePassword(String password) {
    List<String> errors = [];

    if (password.isEmpty) {
      errors.add('Password is required');
      return ValidationResult(isValid: false, errors: errors);
    }

    if (password.length < 8) {
      errors.add('Password must be at least 8 characters');
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add('Password must contain at least one uppercase letter');
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add('Password must contain at least one number');
    }

    if (!password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:\'",.<>?/\\|`~]'))) {
      errors.add('Password must contain at least one special character');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  /// Validates if passwords match
  static bool passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  /// Validates email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({required this.isValid, required this.errors});
}
