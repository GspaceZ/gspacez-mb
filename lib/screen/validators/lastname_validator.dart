class LastnameValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return 'Last name can\'t be empty';
    }
    return null;
  }
}
