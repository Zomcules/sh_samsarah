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

// extension ListTools<T> on List<T> {
//   List<R> translate<R>(R Function(T element) translator) {
//     var list = <R>[];
//     for (var element in this) {
//       list.add(translator(element));
//     }
//     return list;
//   }
// }
