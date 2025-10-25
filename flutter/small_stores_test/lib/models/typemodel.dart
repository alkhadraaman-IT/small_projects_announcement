class ProductType  {
  final int id;
  final int class_id  ;
  final String type_name;
  final String type_name_english;

  ProductType ({
    required this.id,
    required this.class_id  ,
    required this.type_name,
    required this.type_name_english,
  });

  // Factory method to convert JSON to Product object
  factory ProductType .fromJson(Map<String, dynamic> json) {
    return ProductType (
      id: json['id'],
      class_id : json['class_id'],
      type_name: json['type_name'],
      type_name_english: json['type_name_english'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': class_id,
      'type_name': type_name,
      'type_name_english': type_name_english,
    };
  }
}
