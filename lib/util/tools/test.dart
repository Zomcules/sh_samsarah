void main(List<String> args) {
  var link = "samsarahapp:///products?globalId='fJigueE6ljOq6zwNcaSHbqomAPx1'";
  var uri = Uri.parse(link);
  print(uri.path);
  print(uri.queryParameters["globalId"]);
}
