class FirstnameValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return 'First name can\'t be empty';

    } else if (value.length > 20) {
      return 'First name must be between 1 and 20 characters';
    }
    return null;
  }
}

