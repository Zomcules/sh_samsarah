void main() {}

class A extends B<A> {
  @override
  A fun(Map map) {
    // TODO: implement fun
    throw UnimplementedError();
  }

  @override
  Map fun2(A t) {
    // TODO: implement fun2
    throw UnimplementedError();
  }
}

abstract class B<T> {
  T fun(Map map);
  Map fun2(T t);
}
