class CommentModel {
  final int id;
  final int user_id;
  final int product_id;
  final String comment_text;
  final int state;

  CommentModel({
    required this.id,
    required this.user_id,
    required this.product_id,
    required this.comment_text,
    required this.state,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      user_id: json['user_id'],
      product_id: json['product_id'],
      comment_text: json['comment_text'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'product_id': product_id,
      'comment_text': comment_text,
      'state': state,
    };
  }
}
