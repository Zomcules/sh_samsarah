// ignore_for_file: avoid_print

void main() {
  var list = (getElements("Hello!*uid-123123*pid-65465"));
  for (var element in list) {
    print("${element.content} - ${element.type}");
  }
}

List<PostElement> getElements(String source) {
  var temp = <PostElement>[];
  var elemStart = 0;
  for (int i = 0; i < source.length; i++) {
    if (source[i] == "*") {
      temp.add(
        PostElement(
          start: elemStart,
          end: i,
          content: source.substring(elemStart, i),
        ),
      );
      elemStart = i + 1;
    } else if (i == source.length - 1) {
      temp.add(
        PostElement(
          start: elemStart,
          end: i,
          content: source.substring(elemStart, i + 1),
        ),
      );
    }
  }
  return temp;
}

class PostElement {
  int start;
  int end;
  String content;
  PostElement({
    required this.start,
    required this.end,
    required this.content,
  });

  bool get isProduct => content.startsWith("pid-");
  bool get isAcc => content.startsWith("uid-");
  bool get isText => !isProduct && !isAcc;

  String get type {
    if (isProduct) return "prod";
    if (isAcc) return "acc";
    return "txt";
  }
}
