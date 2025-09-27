import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:small_stores_test/createuser.dart';
import 'package:small_stores_test/forgotpassword.dart';
import 'package:small_stores_test/mainpageadmin.dart';
import 'package:small_stores_test/mainpageuser.dart';
import 'package:small_stores_test/models/usermodel.dart';
import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';

import 'apiService/api_service.dart';
import 'apiService/auth_service_api.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();

  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void dispose() {
    _emailController.dispose();
    _passWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(app_name, style: style_name_app_o(color_main)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image_login,
                  SizedBox(height: 8),
                  Text(a_login_b, style: style_text_titel),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: a_email_l,
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return a_email_m;
                      if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
                        return 'البريد الإلكتروني غير صالح';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passWordController,
                    decoration: InputDecoration(
                      labelText: a_password_l,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible ? Icons.remove_red_eye : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !isPasswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_password_m; // رسالة خطأ إذا كانت الخانة فارغة
                      }
                      return null; // لا يوجد خطأ إذا تحققت الشروط
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: Text(a_reset_password_l)),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: Text("نغير كلمة المرور باستخدام البريد الإلكتروني", style: style_text_button_normal(color_main), textDirection: TextDirection.rtl,textAlign: TextAlign.right,),
                      ),
                    ],
                  ),
                  //),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: styleButton(color_main),
                    onPressed: _isLoading
                        ? null // تعطيل الزر إذا كانت العملية قيد التنفيذ
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true; // بدء حالة التحميل
                        });

                        try {
                          final result = await AuthService.login(
                            _emailController.text.trim(),
                            _passWordController.text.trim(),
                          );
                          print('Email: ${_emailController.text.trim()}');
                          print('Password: ${_passWordController.text.trim()}');

                          if (result.containsKey('user') && result.containsKey('access_token')) {
                            final user = User.fromJson(result['user']);
                            final userToken = result['access_token'];

                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('access_token', userToken);
                            await prefs.setInt('userId', user.id);
                            await prefs.setString('userName', user.name);
                            await prefs.setString('userPhone', user.phone);
                            await prefs.setString('userEmail', user.email);
                            await prefs.setString('userPassword', user.password ?? "");
                            await prefs.setString('userPhoto', user.profile_photo ?? image_user_path);
                            await prefs.setInt('userType', user.type);
                            await prefs.setInt('userStatus', user.status);

                            final apiService = ApiService(client: http.Client());
                            apiService.setToken(userToken);

                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('فشل في تكوين بيانات المستخدم')),
                              );
                              return;
                            }

                            print('User ID: ${user.id}');
                            print('User Name: ${user.name}');

                            if (user.type == 0) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MainPageAdmin(user: user)),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MainPageUser(user: user)),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('بيانات تسجيل الدخول غير صحيحة')),
                            );
                          }
                        } catch (e) {
                          String errorMessage = 'فشل تسجيل الدخول';

                          if (e.toString().contains('البريد الإلكتروني غير مسجل')) {
                            errorMessage = 'البريد الإلكتروني غير مسجل في النظام';
                          } else if (e.toString().contains('الحساب محظور')) {
                            errorMessage = 'الحساب محظور. يرجى التواصل مع الدعم';
                          } else if (e.toString().contains('غير صحيحة')) {
                            errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
                          } else {
                            errorMessage = 'حدث خطأ غير متوقع: $e';
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false; // إنهاء حالة التحميل
                          });
                        }
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3, // ثلث عرض الشاشة
                      child: _isLoading
                          ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white, // لون دائرة التحميل
                          strokeWidth: 2, // سمك الخط
                        ),
                      )
                          : Center(
                        child: Text(
                          a_login_b, // نص الزر
                          textAlign: TextAlign.center, // توسيط النص
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center, // ← تمركز العناصر في المنتصف
                    children: [
                      Text(
                        a_createuser_q_s,
                        style: style_text_normal,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateUser()),
                          );
                        },
                        child: Text(
                          a_createuser_b,
                          style: style_text_button_normal(color_main),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
