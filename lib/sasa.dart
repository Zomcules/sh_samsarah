// ignore_for_file: avoid_print

void main(List<String> args) {
  List<Person> list = [
    Person(name: "ahmed", wife: Wife(name: "Amna")),
    Person(name: "ali", wife: Wife(name: "Mona"))
  ];

  List<Wife> wifes = List.generate(
    list.length,
    (index) => list[index].wife,
  );
  list.clear();
  print(wifes.toString());
  print(list.toString());
}

class Person extends Object {
  String name;
  Wife wife;
  Person({required this.name, required this.wife});
  @override
  String toString() {
    return name.toString();
  }
}

class Wife {
  String name;
  Wife({required this.name});
  @override
  String toString() {
    return name.toString();
  }
}
