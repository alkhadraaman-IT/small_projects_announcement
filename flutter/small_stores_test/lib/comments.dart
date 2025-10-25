import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/variables.dart';
import 'apiService/api_service.dart';
import 'apiService/comment_service.dart';
import 'apiService/user_api.dart';
import 'models/commentsmodel.dart';
import 'style.dart';

class CommentsPage extends StatefulWidget {
  final int product_id;
  final int user_id; // ID المستخدم الحالي لإرسال التعليق

  const CommentsPage({Key? key, required this.product_id, required this.user_id}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<CommentModel> comments = [];
  Map<int, String> userNames = {}; // user_id -> اسم المستخدم
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;

  late CommentService commentService;
  late UserApi userApi;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService(client: http.Client());
    commentService = CommentService(apiService: apiService);
    userApi = UserApi(apiService: apiService);
    fetchComments();
  }

  // جلب التعليقات
  Future<void> fetchComments() async {
    try {
      final fetchedComments = await commentService.fetchComments(widget.product_id);

      // جلب أسماء المستخدمين لكل تعليق
      for (var comment in fetchedComments) {
        if (!userNames.containsKey(comment.user_id)) {
          try {
            final user = await userApi.getUser(comment.user_id);
            userNames[comment.user_id] = user.name;
          } catch (_) {
            userNames[comment.user_id] = '$a_user_type_default ${comment.user_id}';
          }
        }
      }

      setState(() {
        comments = fetchedComments;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching comments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  // إضافة تعليق جديد
  Future<void> addComment(String text) async {
    if (text.trim().isEmpty) return;

    try {
      final newComment = await commentService.addComment(widget.product_id, widget.user_id, text);

      // جلب اسم المستخدم الجديد
      String username;
      try {
        final user = await userApi.getUser(newComment.user_id);
        username = user.name;
        userNames[newComment.user_id] = username;
      } catch (_) {
        username = '$a_user_type_default ${newComment.user_id}';
      }

      setState(() {
        comments.insert(0, newComment);
        _controller.clear();
      });
      _scrollToTop();
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : comments.isEmpty
                ? Center(child: Text(comment_no))
                : ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                final username = userNames[comment.user_id] ?? '$a_user_type_default ${comment.user_id}';
                return CommentWidget(
                  username: username,
                  comment: comment.comment_text,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: comment_you,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => addComment(_controller.text),
                  style: styleButton(color_main),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final String username;
  final String comment;

  const CommentWidget({Key? key, required this.username, required this.comment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color_main, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(username, style: TextStyle(fontWeight: FontWeight.bold,)),
            ]
          ),
          SizedBox(height: 4),
          Text(comment, style: TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
