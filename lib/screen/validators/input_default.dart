class InputDefaultValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return 'Input can\'t be empty';
    } else if (value.length > 20) {
      return 'Input must be between 1 and 20 characters';
    }
    return null;
  }
}

