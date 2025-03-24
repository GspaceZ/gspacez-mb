class DateUtils {
  static DateTime parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now();
    }

    try {
      dateString = dateString.replaceAll(RegExp(r'\s+'), ' ').trim();

      List<String> parts = dateString.split(", ");
      List<String> dateParts = parts[0].split("/");

      if (dateParts.length != 3 || parts.length != 2) {
        throw FormatException("Invalid date format: $dateString");
      }

      List<String> timeParts = parts[1].split(" ");

      int month = int.parse(dateParts[0]);
      int day = int.parse(dateParts[1]);
      int year = 2000 + int.parse(dateParts[2]);

      List<String> hourMinuteParts = timeParts[0].split(":");
      int hour = int.parse(hourMinuteParts[0]);
      int minute = int.parse(hourMinuteParts[1]);

      if (timeParts[1].toUpperCase() == "PM" && hour < 12) {
        hour += 12;
      } else if (timeParts[1].toUpperCase() == "AM" && hour == 12) {
        hour = 0;
      }

      return DateTime(year, month, day, hour, minute);
    } catch (e) {
      throw FormatException("Invalid date format: $dateString");
    }
  }
}
