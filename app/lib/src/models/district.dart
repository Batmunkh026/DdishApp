class District {
  final int id;
  final String name;

  District({this.id, this.name});

  @override
  String toString() => name ?? "null";
}
