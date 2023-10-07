class AppInfo {
  String phoneNumber;
  String email;
  String location;
  AppInfo(
      {required this.phoneNumber, required this.email, required this.location});

  factory AppInfo.fromFirestore(Map<String, dynamic> map) {
    return AppInfo(
        phoneNumber: map["phoneNumber"],
        email: map["email"],
        location: map["location"]);
  }
}
