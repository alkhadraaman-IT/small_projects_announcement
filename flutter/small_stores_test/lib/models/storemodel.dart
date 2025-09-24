class store {
  final int id;
  final int user_id  ;
  final String store_name   ;
  final int store_phone  ;
  final String store_place ;
  final int class_id  ;
  final String store_description ;
  final bool store_state ;
  final String store_photo ;

  store({
    required this.id,
    required this.user_id  ,
    required this.store_name   ,
    required this.store_phone   ,
    required this.store_place  ,
    required this.class_id   ,
    required this.store_description  ,
    required this.store_state ,
    required this.store_photo ,
  });

  // Factory method to convert JSON to Product object
  factory store.fromJson(Map<String, dynamic> json) {
    return store(
      id: json['id'],
      user_id  : json['user_id'],
      store_name   : json['store_name'],
      store_phone  : json['store_phone  '],
      store_place : json['store_place '],
      class_id  : json['class_id'],
      store_description : json['store_description '],
      store_state : json['store_state'],
      store_photo : json['store_photo'],
    );
  }
}
