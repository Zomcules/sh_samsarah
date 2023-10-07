import 'dart:io';

extension IntTools on int {
  /// Returns a [String] annotated to ease reading
  String annotate() {
    var string = toString();
    String newString = "";
    for (int i = 0; i < string.length; i++) {
      newString += string[i];
      if ((string.length - i) % 3 == 1 && i != string.length - 1) {
        newString += ",";
      }
    }
    return newString;
  }

  bool isInRangeOf(num first, num second) =>
      (this <= first && this >= second) || (this <= second && this >= first);
}

extension FileTools on File {
  String get fullName => path.split(Platform.pathSeparator).last;
  String get extension => fullName.split(".").last;
}

extension DatetimeTool on DateTime {
  String formatDate() {
    final date = this;
    final diff = DateTime.now().difference(date);
    // if less than hour gives -1
    if (diff.compareTo(const Duration(hours: 1)) <= 0) {
      return "الان";
    }
    if (diff.compareTo(const Duration(days: 1)) <= 0) {
      return "اليوم";
    }
    if (diff.compareTo(const Duration(days: 3)) <= 0) {
      return "منذ يومين";
    }
    if (diff.compareTo(const Duration(days: 6)) <= 0) {
      return "منذ ${diff.inDays.toString()} أيام";
    }
    if (diff.compareTo(const Duration(days: 8)) <= 0) {
      return "منذ أسبوع";
    }
    return "${date.day}-${date.month}-${date.year}";
  }
}
