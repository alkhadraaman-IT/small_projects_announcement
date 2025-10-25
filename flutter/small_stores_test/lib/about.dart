import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class About extends StatefulWidget {
  final User user; // إضافة المتغير

  const About({super.key, required this.user});

  @override
  _About createState() => _About();
}

class _About extends State<About> {

  final String appDownloadUrl = "https://t.me/+v4NgmPududc4YWJk";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user,),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              image_logo_b,
              SizedBox(height: 16),
              Text(a_app_note_s,style: style_text_titel),
              SizedBox(height: 16),
              Text(a_not_s,style: style_text_normal,),
              SizedBox(height: 16),
              Text("للتواصل عبر البريد الالكتروني:Dukkani@gmaul.com",style: style_text_normal,),
              SizedBox(height: 16),
              Text("حمّل تطبيقنا عبر مسح هذا الكود:", style: style_text_titel),
              const SizedBox(height: 12),
              QrImageView(
                data: appDownloadUrl,
                version: QrVersions.auto,
                size: 160.0,
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),)
      ),
    );
  }
}