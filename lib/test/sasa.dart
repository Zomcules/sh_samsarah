// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:async';

void main() async {}

StreamSubscription fun() {
  return Stream.periodic(Duration(seconds: 1)).listen((event) {
    print("hi");
  });
}

StreamSubscription sub = fun();

String name = "hahaha";
String ha = name.substring(0);
