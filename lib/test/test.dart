// ignore_for_file: avoid_print

main() {
  final uri = Uri.parse('samsarahapp://accounts/find?id=abcdefg123');
  print("uri.authority");
  print(uri.authority);
  print("uri.data");
  print(uri.data);
  print("uri.fragment");
  print(uri.fragment);
  print("uri.host");
  print(uri.host);
  // print("uri.origin");
  // print(uri.origin);
  print("uri.path");
  print(uri.path);
  print("uri.pathSegments");
  print(uri.pathSegments);
  print("uri.port");
  print(uri.port);
  print("uri.query");
  print(uri.query);
  print("uri.queryParameters");
  print(uri.queryParameters);
  print("uri.queryParametersAll");
  print(uri.queryParametersAll);
  print("uri.scheme");
  print(uri.scheme);
  print("uri.userInfo");
  print(uri.userInfo);
}

// DONT USE ORIGIN
