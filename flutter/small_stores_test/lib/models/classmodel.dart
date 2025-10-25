class ClassModel {
  final int id;
  final String class_name;
  final String class_name_english; // الاسم الإنجليزي

  ClassModel({
    required this.id,
    required this.class_name,
    required this.class_name_english,

  });

  // Factory method to convert JSON to Product object
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      class_name: json['class_name'],
      class_name_english: json['class_name_english'] ?? '',
    );
  }
}
