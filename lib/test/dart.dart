// ignore_for_file: avoid_print

import 'dart:io';

void main() async {
  print({"email": email(), "password": password()});
}

String email() {
  print("email:");
  return stdin.readLineSync() ?? "";
}

String password() {
  print("password:");
  return stdin.readLineSync() ?? "";
}
