class Type {
  final int id;
  final int class_id  ;
  final String type_name;

  Type({
    required this.id,
    required this.class_id  ,
    required this.type_name,
  });

  // Factory method to convert JSON to Product object
  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['id'],
      class_id : json['class_id '],
      type_name: json['type_name'],
    );
  }
}
