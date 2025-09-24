class store_classes {
  final int id;
  final String class_name;

  store_classes({
    required this.id,
    required this.class_name,
  });

  // Factory method to convert JSON to Product object
  factory store_classes.fromJson(Map<String, dynamic> json) {
    return store_classes(
      id: json['id'],
      class_name: json['class_name'],
    );
  }
}
