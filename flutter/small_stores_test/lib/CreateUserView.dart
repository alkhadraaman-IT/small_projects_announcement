import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:small_stores_test/login.dart';
import 'dart:io';

import 'apiService/api_service.dart';
import 'apiService/auth_service_api.dart';
import 'apiService/user_api.dart';
import 'mainpageuser.dart';
import 'style.dart';
import 'variables.dart';
import 'models/usermodel.dart'; // تأكد من استيراد نموذج User

class CreateUserView extends StatefulWidget {
  @override
  _CreateUserView createState() => _CreateUserView();
}

class _CreateUserView extends State<CreateUserView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isPasswordVisible = false;
  bool _isFingerprintAdded = false;
  File? _fingerprintImage;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final ApiService apiService = ApiService(client: http.Client());
  late UserApi userApi;
  //bool _isStoreOwner = false; // للتحكم بالـ Switch
  int _userType = 1; // القيمة الافتراضية: مستخدم عادي

  @override
  void initState() {
    super.initState();
    userApi = UserApi(apiService: apiService);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passWordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // دالة لحفظ بيانات المستخدم في الذاكرة المحلية
  Future<void> _saveUserData(User user, String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('user_id', user.id);
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_email', user.email);
      await prefs.setString('user_phone', user.phone);
      await prefs.setString('user_token', token);

      print('تم حفظ بيانات المستخدم في الذاكرة المحلية');
    } catch (e) {
      print('خطأ في حفظ البيانات: $e');
      throw Exception(a_user_data_save_failed);
    }
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
                children: [
                  image_login,
                  SizedBox(height: 16),
                  Text(a_createuser_s, style: style_text_titel),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: a_first_name_l,
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                      FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_first_name_m;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: a_last_name_l,
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                      FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_last_name_m;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: a_email_l,
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_email_m;
                      }
                      if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
                        return a_invalid_email_format;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passWordController,
                    decoration: InputDecoration(
                      labelText: a_password_l,
                      prefixIcon: Icon(Icons.lock_open),
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
                        return a_password_m;
                      }
                      if (value.length < 8) {
                        return a_password_too_short;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: a_phone_l,
                      prefixIcon: Icon(Icons.phone),
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '+963',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9),
                      FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return a_phone_m;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),


                  SizedBox(height: 16),
                  // زر Switch لتحديد صاحب متجر
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(a_store_owner_label, style: style_text_normal),
                      Switch(
                        value: _isStoreOwner,
                        onChanged: (bool value) {
                          setState(() {
                            _isStoreOwner = value;
                            _userType = value ? 1 : 2; // إذا مفعّل type = 1 وإلا type = 2
                          });
                        },
                        activeColor: color_main,
                      ),
                    ],
                  ),*/
                  Text("لإنشاء حساب صاحب مشروع يرجى التواصل مع المدير عبر البريد الالكتروني: alkhadraaman@gmail.com", style: style_text_normal),

                  SizedBox(height: 16),

                  ElevatedButton(
                    style: styleButton(color_main),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        final result = await AuthService.register(
                          name: '${_firstNameController.text} ${_lastNameController.text}',
                          email: _emailController.text,
                          phone: '+963 ${_phoneController.text}',
                          password: _passWordController.text,
                          type: 2, // إرسال النوع
                        );

                        setState(() => _isLoading = false);

                        if (result['status'] == 200) {
                          final user = User.fromJson(result['user']);
                          final token = result['access_token'];
                          // حفظ البيانات والانتقال للصفحة الرئيسية
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(a_account_created_success)),
                          );
                        } else {
                          // الرسالة القادمة من السيرفر مباشرة
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result['message'])),
                          );
                        }
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3, // ثلث عرض الشاشة
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(a_login_b,textAlign: TextAlign.center,),

                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}