import 'package:flutter/material.dart';
import 'package:small_stores_test/announcement.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'appbar.dart';
import 'drawer.dart';
import 'style.dart';
import 'variables.dart';

class AddAnnouncement extends StatefulWidget {
  @override
  _AddAnnouncement createState() => _AddAnnouncement();
}

class _AddAnnouncement extends State<AddAnnouncement> {
  final TextEditingController _announcementNoteController = TextEditingController();
  final TextEditingController _announcementImageController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // ✅ مفتاح الـ Form


  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _announcementImageController.text = pickedFile.path;
      });
    }
  }


  @override
  void dispose() {
    _announcementNoteController.dispose();
    _announcementImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
        child: Center(
        child: Padding(
        padding: const EdgeInsets.all(24.0),
    child: Form( // ✅ إحاطة النموذج بـ Form
    key: _formKey,
    child: Column(
    children: [
                image_login,
                SizedBox(height: 16),
                Text(a_AddAnnouncement_s,style: style_text_titel),
                SizedBox(height: 16),
                TextFormField(
                  controller: _announcementNoteController,
                  decoration: InputDecoration(
                    labelText: a_text_Announcement_l,
                    prefixIcon: Icon(Icons.sticky_note_2_rounded),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return a_store_name_m;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(  // <<=== هذا هو المفتاح
                      child: TextFormField(
                        controller: _announcementImageController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: a_photo_Announcement_l,
                          prefixIcon: Icon(Icons.image),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return a_store_logo_m;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: style_button,
                      onPressed: _pickImage,
                      child: Text(a_add_b),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(style: style_button,onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Announcement()),
                    );
                  }
                }, child: Text(a_add_b)),
                SizedBox(height: 16),

              ]

          ),
        ),
      ),
    )
        )
    );
  }
}