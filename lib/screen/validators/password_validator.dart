class PasswordValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return 'Password can\'t be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}
