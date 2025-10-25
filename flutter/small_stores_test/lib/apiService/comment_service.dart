import '../models/commentsmodel.dart';
import 'api_service.dart';

class CommentService {
  final ApiService apiService;
  CommentService({required this.apiService});

  // جلب التعليقات
  Future<List<CommentModel>> fetchComments(int productId) async {
    final response = await apiService.get('comments/view/$productId');
    // Laravel قد يرجع JSON مباشرة أو مع مفتاح 'data'
    final List commentsData = response['data'] ?? response as List;
    return commentsData
        .map((json) => CommentModel.fromJson(json))
        .toList();
  }

  // إضافة تعليق جديد
  Future<CommentModel> addComment(int productId,int user_id, String text) async {
    final response = await apiService.post('comments/add', {
      'product_id': productId,
      'user_id': user_id,
      'comment_text': text,
    });

    // Laravel يرجع المفتاح 'comment' عند الإضافة
    return CommentModel.fromJson(response['comment']);
  }
}
