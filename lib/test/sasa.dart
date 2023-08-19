// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

void main(List<String> args) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  users
      .add({
        'full_name': 'mohamed', // John Doe
        'company': 'for the streets', // Stokes and Sons
        'age': 50 // 42
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));

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
