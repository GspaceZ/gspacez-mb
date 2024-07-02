class FirstnameValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return 'First name can\'t be empty';
    }
    return null;
  }
}
