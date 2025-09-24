import 'package:flutter/material.dart';
import 'package:small_stores_test/editprofile.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'style.dart';
import 'variables.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // اختياري
      drawer: CustomDrawer(), // اختياري
      body: SingleChildScrollView(
        child: Center(
          child: ProfileBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfile()),
          );
        },
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: color_main,
      ),
    );
  }
}

class ProfileBody extends StatelessWidget {
  final String name = 'ااا';
  final String plane = 'ببب بب';
  final String note = 'تتت ت تت تتتتتت';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // لمحاذاة لليمين
        children: [
          Image.asset('assets/images/img_3.png'),
          SizedBox(height: 16),
          Text(
            '$a_user_name_s: $name',
            style: style_text_normal,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16),
          Text(
            '$a_user_email_s: $plane',
            style: style_text_normal,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16),
          Text(
            '$a_user_phone_s: $note',
            style: style_text_normal,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16),
          Text(
            '$a_user_plan_s: $note',
            style: style_text_normal,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
