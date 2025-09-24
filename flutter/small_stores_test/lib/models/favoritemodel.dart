class favorites {
  final int id;
  final int user_id ;
  final int product_id  ;
  final bool state ;

  favorites({
    required this.id,
    required this.user_id ,
    required this.product_id  ,
    required this.state ,
  });

  // Factory method to convert JSON to Product object
  factory favorites.fromJson(Map<String, dynamic> json) {
    return favorites(
      id: json['id'],
      user_id : json['user_id '],
      product_id  : json['product_id  '],
      state : json['state '],
    );
  }
}
