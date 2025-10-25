import 'package:flutter/material.dart';
import 'package:small_stores_test/addannouncement.dart';
import 'package:small_stores_test/addproduct.dart';
import 'package:small_stores_test/addstore.dart';
import 'package:small_stores_test/announcement.dart';
import 'package:small_stores_test/chekpasswordcode.dart';
import 'package:small_stores_test/createuser.dart';
import 'package:small_stores_test/editproduct.dart';
import 'package:small_stores_test/firstlaunch.dart';
import 'package:small_stores_test/forgotpassword.dart';
import 'package:small_stores_test/login.dart';
import 'package:small_stores_test/mainpageadmin.dart';
import 'package:small_stores_test/product.dart';
import 'package:small_stores_test/profile.dart';
import 'package:small_stores_test/restpassword.dart';
import 'package:small_stores_test/showmystoredata.dart';
import 'about.dart';
import 'editprofile.dart';
import 'home.dart';
import 'mainpageuser.dart';
import 'models/usermodel.dart';
import 'showproduct.dart';
import 'showstore.dart';
import 'showstoredata.dart';
import 'splashscreen.dart';
import 'store.dart';
import 'style.dart';
import 'variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadColor(); // تحميل اللون من الذاكرة
  await loadLanguage(); // تحميل اللغة من الذاكرة
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  void updateTheme() {
    setState(() {}); // يعيد بناء الـ MaterialApp باللون الجديد
  }


  void updateLanguage(String lang) async {
    await saveLanguage(lang);
    setState(() {
      language_app = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = User(
      name: "user6",
      email: "user6@test.com",
      phone: '0988311222',
      password: "123456",
      profile_photo: "profile1.jpg",
      type: 0,
      status: 1,
      id: 2,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(language_app), // استخدام اللغة المحفوظة
      title: 'Dukkani',
      theme: ThemeData(
        scaffoldBackgroundColor: color_background,
        tabBarTheme: tabBarTheme(color_main),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color_Secondary),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelStyle: TextStyle(color: color_Secondary),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: color_Secondary,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: color_main,
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: language_app == "ar" ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      home: Splashscreen(),
    );
  }
}
