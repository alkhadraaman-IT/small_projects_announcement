import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/statistics.dart';

import 'apiService/api_service.dart';
import 'apiService/user_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/usermodel.dart';
import 'product.dart';
import 'profile.dart';
import 'style.dart';
import 'variables.dart';

class ShowFilereQuests extends StatefulWidget {
  final User user;

  const ShowFilereQuests({Key? key, required this.user}) : super(key: key);

  @override
  _ShowFilereQuests createState() => _ShowFilereQuests();
}

class _ShowFilereQuests extends State<ShowFilereQuests> {
  // دالة لعرض تأكيد الحذف بخطوتين
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    // الخطوة الأولى: تأكيد الحذف
    bool? firstConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("تفعيل الحساب", style: style_text_titel),
        content: Text("هل تريد تفعيل هذا الحساب؟" , style: style_text_normal),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(a_cancel, style: style_text_button_normal_2(color_Secondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(a_yes, style: style_text_button_normal_red),
          ),
        ],
      ),
    );

    if (firstConfirm == true) {
      // الخطوة الثانية: التأكيد النهائي
      bool? finalConfirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("تأكيد", style: style_text_titel),
          content: Text("هل انت متاكد من تفعيل الحساب سيحق له فعل وظائفه" , style: style_text_normal),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(a_cancel, style: style_text_button_normal_2(color_Secondary)),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(a_confirm_delete_l, style: style_text_button_normal_red),
            ),
          ],
        ),
      );

      if (finalConfirm == true) {
        _deleteUser();
      }
    }
  }

  // دالة حذف المستخدم
  Future<void> _deleteUser() async {
    try {
      final api = UserApi(apiService: ApiService(client: http.Client()));
      await api.no_deleteUser(widget.user.id);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(a_user_deleted_success ),
          ));

      Navigator.pop(context); // الرجوع بعد الحذف
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$a_user_delete_failed : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileBody(user_id: widget.user.id),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDeleteConfirmation(context),
        child: Icon(Icons.lock_open, color: Colors.white),
        backgroundColor: color_main,
      ),
    );
  }
}