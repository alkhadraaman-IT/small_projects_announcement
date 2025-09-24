class user {
  final int id;
  final String name ;
  final int phone   ;
  final String email  ;
  final String password ;
  final String profile_photo ;
  final bool type ;
  final bool state ;

  user({
    required this.id,
    required this.name ,
    required this.phone   ,
    required this.email   ,
    required this.password  ,
    required this.profile_photo  ,
    required this.type  ,
    required this.state ,
  });

  // Factory method to convert JSON to Product object
  factory user.fromJson(Map<String, dynamic> json) {
    return user(
      id: json['id'],
      name : json['name '],
      phone   : json['phone'],
      email  : json['email  '],
      password : json['password '],
      profile_photo : json['profile_photo '],
      type : json['type '],
      state : json['state '],
    );
  }
}
