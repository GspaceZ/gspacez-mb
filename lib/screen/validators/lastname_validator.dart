class LastnameValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return 'Last name can\'t be empty';
    } else if (value.length > 20) {
      return 'Last name must be between 1 and 20 characters';
    }
    return null;
  }
}

