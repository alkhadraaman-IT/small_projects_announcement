import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  ResetPasswordPage({required this.email});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible1 = false;
  bool isPasswordVisible2 = false;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      print('فات');
      try {
        // طباعة البيانات المرسلة
        print('Emailllll: ${widget.email}');
        print('Passwordddddd: ${_passwordController.text}');
        print('Confirmationnnnnnnn: ${_confirmController.text}');

        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/ChangePassword'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': widget.email,
            'password': _passwordController.text,
            'passwordRet': _confirmController.text,
          }),
        );
        if (response == null) {
          return;
        }

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.body.startsWith('<!DOCTYPE') || response.body.startsWith('<html>')) {
          showError(erorr_html);
          return;
        }

        if (response.statusCode == 200) {
          Navigator.popUntil(context, (route) => route.isFirst);
          showError(a_password_reset_success);
        } else {
          Map<String, dynamic> errorBody = jsonDecode(response.body);
          showError(errorBody['message'] ??a_password_reset_failed );
        }
      } catch (e) {
        showError("$a_error_occurred: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(app_name,style: style_name_app_o(color_main),),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              image_restpassword,
              SizedBox(height: 16),
              Text(a_reset_password_title ,style: style_text_titel,),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: a_new_password ,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        isPasswordVisible1 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible1 = !isPasswordVisible1;
                      });
                    },
                  ),
                ),
                obscureText: !isPasswordVisible1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return a_confirm_password_m ;
                  }
                  if (value.length < 8) {
                    return a_password_too_short; // رسالة خطأ إذا كانت كلمة المرور أقل من 8 أحرف
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmController,
                decoration: InputDecoration(
                  labelText: a_confirm_password ,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        isPasswordVisible2 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible2 = !isPasswordVisible2;
                      });
                    },
                  ),
                ),
                obscureText: !isPasswordVisible2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return a_confirm_password_m ;
                  }
                  if (value != _passwordController.text) {
                    return a_passwords_not_match ;
                  }
                  if (value.length < 8) {
                    return a_password_too_short; // رسالة خطأ إذا كانت كلمة المرور أقل من 8 أحرف
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3, // تلت عرض الشاشة
            child:ElevatedButton(
                onPressed: _resetPassword,
                style: styleButton(color_main),
                child: Text(a_change_password ),
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
